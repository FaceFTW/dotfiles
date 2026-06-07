final: prev: {
  prune-nix-cache = prev.writeShellScriptBin "prune-nix-cache" ''
    PRUNE_DATE=$(date -d "-14days" "+%Y/%m/%d")
    export AWS_REGION="archiver"
    BUCKET_LIST=$(mktemp)
    FILTERED_LIST=$(mktemp)

    ${final.s5cmd}/bin/s5cmd \
      --endpoint-url "http://s3.garage.faceftw.local" \
     	ls \
      "s3://nix-cache/*" \
    > "$BUCKET_LIST"
    echo "Enumerated all files from S3"

    awk \
      -F " +" \
      -v d="$PRUNE_DATE" \
      -v dp="(....)/(..)/(..)" \
      'BEGIN {gensub(dp, "\1\2\3", d)} {dt=$1; gensub(dp, "\3\2\1", dt);} {if (dt <= d) print $4}' \
    	"$BUCKET_LIST" \
     > "$FILTERED_LIST"

    while read line; do
      ${final.s5cmd}/bin/s5cmd \
        --endpoint-url "http://s3.garage.faceftw.local" \
        rm \
        "s3://nix-cache/$line"
    done < "$FILTERED_LIST"

    echo "Finished Pruning :)"
  '';
}
