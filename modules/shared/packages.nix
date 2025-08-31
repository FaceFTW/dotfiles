{ pkgs }:

with pkgs; [
  # General packages for development and system management
  bash-completion
  bat
  btop
  coreutils
  killall
  neofetch
  openssh
  wget
  zip

  # Encryption and security tools
  age
  gnupg

  # Cloud-related tools and SDKs
  docker
  docker-compose
  # Node.js development tools
  nodejs_24

  # Text and terminal utilities
  htop
  iftop
  jq
  ripgrep
  tree
  unrar
  unzip
]
