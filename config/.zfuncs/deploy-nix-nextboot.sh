local host=$1
local addr

# Check if we have a 2nd arg and if it's formatted as a flag we should pass down
if [[ -z "$2" || "$2" =~ "--?([a-zA-Z0-9])+" ]]; then
	addr="$host.internal.faceftw.dev"
	shift 1
else
	addr="$2"
	shift 2
fi

nixos-rebuild boot \
	--print-build-logs --keep-going \
	--no-reexec \
	--flake "/home/face/.config/dotfiles#$host" \
	--sudo --ask-sudo-password \
	--target-host "face@$addr" \
	"$@"
