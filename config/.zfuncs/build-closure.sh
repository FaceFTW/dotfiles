local host=$1
shift 1

case "$host" in
manifold-wsl) host="manifold" ;;
portal-wsl) host="portal" ;;
esac

nix build \
	--print-build-logs --keep-going \
	--no-link \
	"/home/face/.config/dotfiles#nixosConfigurations.$host.config.system.build.toplevel" \
	"$@"
