local hostname=$(cat /etc/hostname)
case "$hostname" in
manifold-wsl) hostname="manifold" ;;
portal-wsl) hostname="portal" ;;
esac

sudo nixos-rebuild boot \
	--print-build-logs --keep-going \
	--no-reexec \
	--flake "/home/face/.config/dotfiles#$hostname" \
	"$@"
