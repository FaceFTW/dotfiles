# Dotfiles

Dotfiles and my NixOS configuration I maintain. Extremely opinionated as all personalized configuration is.

## Overview

I daily-drive Windows for both personal/work use, but I use WSL on all my machines, and also use NixOS for a 3D printer server. Depending on the system I use a different configuration management scheme:

- Windows/Non-NixOS Linux -> [link-cfg](https://github.com/FaceFTW/link-cfg)
  - Symlink/Template system. I can't use NixOS at work for security (booooo)
- NixOS -> Nix Flakes

*Do not expect me to make a config for macOS. It will be a cold day in hell if I do.*

### NixOS System List

| Host Name    | Hardware                                                                                           | Description                                 |
|--------------|----------------------------------------------------------------------------------------------------|---------------------------------------------|
| `manifold`   | WSL Host :window: <br/> <ul><li>AMD Ryzen R7 7700X</li><li>Nvidia GeForce RTX 4070 SUPER</li></ul> | Main System                                 |
| `portal`     | WSL Host :window:<br/> Microsoft Surface Laptop Studio                                             | On-the-go System (not used as often)<br/>   |
| `fabricator` | Raspberry Pi 4                                                                                     | Klipper Server <br/> ***IN DEVELOPMENT***   |
| `archiver`   | Raspberry Pi 4                                                                                     | Makeshift NAS    <br/> ***IN DEVELOPMENT*** |

### Configurations Maintained

Legend

- :white_check_mark: -> Maintained
- :white_circle: -> Probably supported
- :x: -> Not Supported

| Configuration    | Windows            | Linux              | NixOS              |
|------------------|--------------------|--------------------|--------------------|
| PowerShell 7     | :white_check_mark: | :white_circle:     | :x:                |
| Oh My Posh       | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [shell-toy](https://github.com/FaceFTW/shell-toy)<br/> (Fortunes, Cowsay)| :white_check_mark: Prebuilt Custom Binary | :white_check_mark: Prebuilt Custom Binary | :white_check_mark: Local Overlay
| Git              | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| Vim              | :white_check_mark: Using `vim_plug` | :white_check_mark: Using `vim_plug` | :white_check_mark: Plugins installed via Nix |
| Zsh              | :x: | :white_check_mark: | :white_check_mark: via Home Manager |
| Counter-Strike 2 | :white_check_mark: | :white_circle:     | :white_circle:                |