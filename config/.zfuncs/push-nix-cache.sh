sudo nix store sign --all \
	--key-file /etc/secrets/nix-cache.pem

nix copy --all \
	--to 's3://nix-cache?endpoint=garage-s3.faceftw.dev' \
	--option narinfo-cache-positive-ttl 0
