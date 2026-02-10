{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    ;
  defaultUser = config.defaultUser;
  systemUser = config.systemUser;

  sysUserSpec =
    with types;
    submodule {
      home = mkOption {
        type = types.str;
        description = "Path to the home directory of this system user";
      };
      extraGroups = mkOption {
        type = with types; listOf str;
        description = "Additional groups this system user should have";
      };
    };

  mkSysUser =
    name:
    { home, extraGroups, ... }:
    {
      isSystemUser = true;
      home = home;
      group = "${name}";
      extraGroups = extraGroups;
    };

in
{
  # NOTE: Assumes Home-Manager NixOS module is added to host module
  imports = [ ];

  options.defaultUser = {
    password = mkOption {
      type =
        with types;
        submodule {
          options.type = mkOption {
            type = enum [
              "sops"
              "initialPassword"
            ];
          };
          options.value = mkOption { type = str; };
        };
      description = ''
        Defines how the password for the `face` user is set.
        Type `sops` indicates `value` is a SOPS path for `hashedPassword`,
        type `initialPassword` passes the value to `initialHashedPassword`
      '';
    };
    extraGroups = mkOption {
      type = with types; listOf str;
      description = ''
        List of groups to add to the `face` user. Note that `wheel` is always added as a group to this user.
      '';
      default = [ ];
    };
    extraPackages = mkOption {
      type = with types; listOf package;
      description = "List of packages to add to the `face` user";
      default = [ ];
    };
  };

  options.systemUser = mkOption {
    type = with types; attrsOf sysUserSpec;
    description = "Definitions of system users";
    default = { };
  };

  config = mkMerge [
    {
      ############################################
      # Default User Settings
      ############################################
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.face = {
        home.enableNixpkgsReleaseCheck = false;
        home.username = "face";
        home.homeDirectory = "/home/face";
        xdg.enable = true;

        programs = (import ./home.nix { inherit config pkgs lib; });

        home.stateVersion = "25.05";
      };

      users.users.face = {
        home = "/home/face";
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ]
        ++ defaultUser.extraGroups;
        shell = pkgs.zsh;
        packages = defaultUser.extraPackages;
        initialPassword = mkIf (defaultUser.password.type == "initialPassword") defaultUser.password.value;
        hashedPasswordFile = mkIf (defaultUser.password.type == "sops") defaultUser.password.value;
      };
    }
    # (builtins.mapAttrs (name: userdef: {
    #   name = "${name}";
    #   value = {
    #     users.users.${name} = (mkSysUser name userdef);
    #     users.groups.${name} = { };
    #   };
    # }) systemUser)
  ];

}
