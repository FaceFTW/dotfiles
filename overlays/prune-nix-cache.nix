final: prev: {
  prune-nix-cache = prev.writeShellScriptBin "prune-nix-cache" ''
    set -euo pipefail

    export AWS_REGION="archiver"
    endpoint="http://garage-s3.faceftw.dev"
    flake_ref="/home/face/.config/dotfiles"
    s5cmd="${final.s5cmd}/bin/s5cmd"
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT

    configs="$tmpdir/configs"
    store_paths="$tmpdir/store-paths"
    keep_narinfo="$tmpdir/keep-narinfo"
    object_keys="$tmpdir/object-keys"
    matched_narinfo="$tmpdir/matched-narinfo"
    cp_batch="$tmpdir/cp-batch"
    keep_keys="$tmpdir/keep-keys"
    rm_batch="$tmpdir/rm-batch"
    narinfo_dir="$tmpdir/narinfo"
    mkdir "$narinfo_dir"


    nix eval --json "$flake_ref#nixosConfigurations" \
      --apply 'builtins.attrNames' |
      ${final.jq}/bin/jq -r '.[]' > "$configs"


    if [ ! -s "$configs" ]; then
      echo "No nixosConfigurations found in $flake_ref" >&2
      exit 1
    fi

    : > "$store_paths"
    while IFS= read -r config; do
      echo "Resolving latest flake system derivation: $config"
      drv=$(nix eval --raw \
        "$flake_ref#nixosConfigurations.$config.config.system.build.toplevel.drvPath")
      nix-store --query --requisites --include-outputs "$drv" >> "$store_paths"
    done < "$configs"

    while IFS= read -r store_path; do
      store_name="''${store_path##*/}"
      store_hash="''${store_name%%-*}"
      if [[ "$store_hash" =~ ^[0-9a-z]{32}$ ]]; then
        printf '%s.narinfo\n' "$store_hash"
      fi
    done < "$store_paths" | sort -u > "$keep_narinfo"
    if [ ! -s "$keep_narinfo" ]; then
      echo "No store paths found; refusing to prune the cache" >&2
      exit 1
    fi

    "$s5cmd" --endpoint-url "$endpoint" ls "s3://nix-cache/*" |
      awk '{print $NF}' |
      sed 's#^s3://[^/]*/##' > "$object_keys"
    if [ ! -s "$object_keys" ]; then
      echo "Cache listing is empty; refusing to prune" >&2
      exit 1
    fi
    while IFS= read -r key; do
      if [[ ! "$key" =~ ^[A-Za-z0-9._/+:-]+$ ]]; then
        echo "Unexpected cache object key; refusing to prune: $key" >&2
        exit 1
      fi
    done < "$object_keys"

    awk 'NR == FNR { wanted[$0] = 1; next } $0 in wanted { print }' \
      "$keep_narinfo" "$object_keys" > "$matched_narinfo"
    if [ ! -s "$matched_narinfo" ]; then
      echo "No latest system derivations are present in the cache; refusing to prune" >&2
      exit 1
    fi

    while IFS= read -r key; do
      printf 'cp "s3://nix-cache/%s" "%s/%s"\n' \
        "$key" "$narinfo_dir" "''${key##*/}"
    done < "$matched_narinfo" > "$cp_batch"
    "$s5cmd" --endpoint-url "$endpoint" run "$cp_batch"

    {
      echo "nix-cache-info"
      cat "$matched_narinfo"
      while IFS= read -r narinfo; do
        url=$(awk -F ': ' '$1 == "URL" { print $2; exit }' "$narinfo_dir/''${narinfo##*/}")
        if [ -z "$url" ]; then
          echo "Missing URL in cache metadata: $narinfo" >&2
          exit 1
        fi
        case "$url" in
          s3://nix-cache/*) url="''${url#s3://nix-cache/}" ;;
          /*) url="''${url#/}" ;;
        esac
        if [[ ! "$url" =~ ^[A-Za-z0-9._/+:-]+$ ]]; then
          echo "Unexpected NAR URL; refusing to prune: $url" >&2
          exit 1
        fi
        printf '%s\n' "$url"
      done < "$matched_narinfo"
    } | sort -u > "$keep_keys"

    awk 'NR == FNR { keep[$0] = 1; next } !($0 in keep) { print }' \
      "$keep_keys" "$object_keys" |
      while IFS= read -r key; do
        printf 'rm "s3://nix-cache/%s"\n' "$key"
      done > "$rm_batch"

    if [ -s "$rm_batch" ]; then
      echo "Removing obsolete cache objects (including old system generations)"
      "$s5cmd" --endpoint-url "$endpoint" run "$rm_batch"
    else
      echo "Cache already contains only the latest system closures"
    fi
  '';
}
