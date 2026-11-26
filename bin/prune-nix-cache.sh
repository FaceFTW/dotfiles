# #!/bin/bash
# set -euo pipefail

export AWS_REGION="archiver"
endpoint="https://garage-s3.faceftw.dev"
flake_ref="/home/face/.config/dotfiles"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
preserve_paths="$tmpdir/preserve-paths"
object_keys="$tmpdir/object-keys"
rm_batch="$tmpdir/rm-batch"

# Array of NixOS Configurations as a Bash array (which tend to be cringe)
read -r -a nix_configs_list <<< \
    "$(nix eval --json "$flake_ref#nixosConfigurations" --apply 'builtins.attrNames' |
        jq -r '.[]' |
        xargs echo)"
if [ ${#nix_configs_list[@]} == 0 ]; then
    echo "No nixosConfigurations found in $flake_ref" >&2
    exit 1
fi

# Get the GC root of the latest configuration (evaluated/built by Nix already)
# Use that store path and get all the requisites for said derivation
drv_list=()
for nix_config in "${nix_configs_list[@]}"; do
    echo "Resolving latest flake system derivation: $nix_config"
    drv=$(nix eval --raw "$flake_ref#nixosConfigurations.$nix_config.config.system.build.toplevel.drvPath")
    mapfile -t drv_list_config <<< "$(nix-store --query --requisites --include-outputs "$drv")"
    drv_list+=( "${drv_list_config[@]}" )
done

# Nix caches have two files for a cached derivation, narinfo and nar, with
# the name as the evaluated derivation hash
#
# Make a list and write it as a preserve path list
for drv_path in "${drv_list[@]}"; do
    drv_name="${drv_path##*/}"
    drv_hash="${drv_name%%-*}"
    if [[ "$drv_hash" =~ ^[0-9a-z]{32}$ ]]; then
        narinfo_path="$drv_hash.narinfo"
        nar_path="nar/$drv_hash.nar.xz"
        echo "$narinfo_path" >> "$tmpdir/preserve_paths_unsorted"
        echo "$nar_path" >> "$tmpdir/preserve_paths_unsotred"
    fi
done
if [ ! -s "$tmpdir/preserve_paths_unsorted" ]; then
    echo "No store paths found; refusing to prune the cache" >&2
    exit 1
fi
sort -u "$tmpdir/preserve_paths_unsorted" > "$preserve_paths"
echo "Identified $(wc -l "$preserve_paths" | sed "s#$preserve_paths##")paths that are in latest GC roots"

# Get files currently in Nix Cache
# ignore the nix-cache-info file since that is metadata about the cache
s5cmd --endpoint-url "$endpoint" ls --exclude "nix-cache-info" "s3://nix-cache/*" |
    awk '{print $NF}' |
    sed 's#^s3://[^/]*/##' > "$object_keys"
if [ ! -s "$object_keys" ]; then
    echo "Cache listing is empty; refusing to prune" >&2
    exit 1
fi

# Filter out the files that are in latest GC roots
# Then make it the proper S3 urls
grep --invert-match --fixed-strings -f "$preserve_paths" "$object_keys" > "$tmpdir/rm-batch-nourl"
echo "Identified $(wc -l "$tmpdir/rm-batch-nourl" | sed "s#$tmpdir/rm-batch-nourl##")paths to remove from cache"
awk '{print "rm s3://nix-cache/" $0}' "$tmpdir/rm-batch-nourl" > "$rm_batch"

# Do the remove operation
echo "Triggering removal"
s5cmd --endpoint-url "$endpoint" run "$rm_batch"
