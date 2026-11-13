# Dotfiles

Dotfiles and my NixOS configuration I maintain. Extremely opinionated as all personalized configuration should be.

_**NOTE: Do not expect tech support when trying to use these configs for your own purposes. Issues/PRs are still
welcome if you find something wrong that I should be aware of.**_

## Overview

- Windows/Non-NixOS Linux Configurations -> [link-cfg](https://github.com/FaceFTW/link-cfg)
    - Symlink/Template system
- NixOS -> Nix Flakes

### NixOS System List

| Host Name    | Hardware                                                                                                            | Description                               |
| ------------ | ------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| `manifold`   | <ul><li>AMD Ryzen R7 7700X</li><li>Nvidia GeForce RTX 4070 SUPER</li></ul>WSL Host :window:                         | Main System                               |
| `theseus`    | Framework Laptop 13 Pro<br/><ul><li>Intel Panther Lake Core Ultra X7 358H</li></ul>                                 | On-the-go System<br/>With Full NixOS Rice |
| `fabricator` | Raspberry Pi 4                                                                                                      | Klipper Server                            |
| `archiver`   | UGREEN NASync DXP2800<br/><ul><li>16GB DDR5</li><li>14TB SATA Btrfs RAID1</li><li>500GB NVMe Btrfs RAID 1</li></ul> | NAS/Self-hosting Server                   |
| `durandal`   | Raspberry Pi Model 3B+ (1GB? need to check)                                                                         | Local DNS Server                          |

### Additional Notes

All wallpapers are slightly altered from the original work of [Francis Xie](https://x.com/FrancisXie_sfw).
It features V1 from [ULTRAKILL by Hakita](https://store.steampowered.com/app/1229490/ULTRAKILL/), which is a
copyright of New Blood Interactive (I do not own any of this obviously).

This repository distributes a copy of the VCR OSD Mono font by Riciery Leal, which is 100% free. It can be found on
[DaFont](https://www.dafont.com/vcr-osd-mono.font) with this link.

Portions of FRAUDSHELL (the theseus Quickshell theme) uses significant code (modified or verbatim) from the following
sources (attribution exists in specific files):

- [end-4/dots-hyprland (illogical-impulse)](https://github.com/end-4/dots-hyprland)
- [nydragon/nysh](https://github.com/nydragon/nysh)
