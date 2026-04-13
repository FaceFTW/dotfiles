# Dotfiles

Dotfiles and my NixOS configuration I maintain. Extremely opinionated as all personalized configuration should be.

_**NOTE: Do not expect tech support when trying to use these configs for your own purposes. Issues/PRs are still welcome if you find something wrong that I should be aware of.**_

## Overview

I daily-drive Windows for both personal/work use, but I use WSL on all my machines, and also use NixOS for a 3D printer server. Depending on the system I use a different configuration management scheme:

- Windows/Non-NixOS Linux -> [link-cfg](https://github.com/FaceFTW/link-cfg)
    - Symlink/Template system. I can't use NixOS at work for security (booooo)
- NixOS -> Nix Flakes

_Do not expect me to make a config for macOS. It will be a cold day in hell if I do._

### NixOS System List

| Host Name    | Hardware                                                                                                            | Description                                                         |
| ------------ | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `manifold`   | <ul><li>AMD Ryzen R7 7700X</li><li>Nvidia GeForce RTX 4070 SUPER</li></ul>WSL Host :window:                         | Main System                                                         |
| `nemesis`    | Microsoft Surface Laptop Studio<br/>Dual-boots into `portal` :window:                                               | On-the-go System<br/>With Full NixOS Rice<br/> **_IN DEVELOPMENT_** |
| `portal`     | Microsoft Surface Laptop Studio<br/> WSL Host :window:                                                              | On-the-go System (Windows Side)<br/>                                |
| `fabricator` | Raspberry Pi 4                                                                                                      | Klipper Server                                                      |
| `archiver`   | UGREEN NASync DXP2800<br/><ul><li>16GB DDR5</li><li>14TB SATA Btrfs RAID1</li><li>500GB NVMe Btrfs RAID 1</li></ul> | NAS/Self-hosting Server                                             |
| `durandal`   | Raspberry Pi Model 3B+ (1GB? need to check)                                                                         | Local DNS Server                                                    |

### Configurations Maintained

Legend

- :white_check_mark: -> Maintained
- :white_circle: -> Probably supported
- :x: -> Not Supported

| Configuration                                                             | Windows                                   | Linux                                     | NixOS                                        |
| ------------------------------------------------------------------------- | ----------------------------------------- | ----------------------------------------- | -------------------------------------------- |
| PowerShell 7                                                              | :white_check_mark:                        | :white_circle:                            | :x:                                          |
| Oh My Posh                                                                | :white_check_mark:                        | :white_check_mark:                        | :white_check_mark:                           |
| [shell-toy](https://github.com/FaceFTW/shell-toy)<br/> (Fortunes, Cowsay) | :white_check_mark: Prebuilt Custom Binary | :white_check_mark: Prebuilt Custom Binary | :white_check_mark: Local Overlay             |
| Git                                                                       | :white_check_mark:                        | :white_check_mark:                        | :white_check_mark:                           |
| Vim                                                                       | :white_check_mark: Using `vim_plug`       | :white_check_mark: Using `vim_plug`       | :white_check_mark: Plugins installed via Nix |
| Zsh                                                                       | :x:                                       | :white_check_mark:                        | :white_check_mark: via Home Manager          |
| Counter-Strike 2                                                          | :white_check_mark:                        | :white_circle:                            | :white_circle:                               |
| Zed                                                                       | :white_check_mark:                        | :white_circle:                            | :white_check_mark:                           |

### Additional Notes

Information about the Nemesis rice is in-progress

All wallpapers are slightly altered from the original work of [Francis Xie](https://x.com/FrancisXie_sfw). It features V1 from [ULTRAKILL by Hakita](https://store.steampowered.com/app/1229490/ULTRAKILL/), which is a copyright of New Blood Interactive (I do not own any of this obviously).

This repository distributes a copy of the VCR OSD Mono font by Riciery Leal, which is 100% free. It can be found on [DaFont](https://www.dafont.com/vcr-osd-mono.font) with this link.
