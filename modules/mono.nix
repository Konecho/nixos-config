{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf mkOption types;
  cfg = config.mono;
in {
  options.mono.enable = mkOption {
    type = types.bool;
    default = true;
    example = false;
    description = "";
  };
  options.mono.username = mkOption {
    type = types.str;
    default = "alice";
    example = "bob";
    description = "";
  };
  options.mono.groupsAdd = mkOption {
    type = types.nullOr (types.listOf types.str);
    default = null;
    example = [];
    description = "";
  };
  imports = [./alias.nix];
  config = {
    users.groups = builtins.listToAttrs (map (n: {
        name = n;
        value = {members = [cfg.username];};
      })
      cfg.groupsAdd);

    # alias user to users.users.<name> in alias.nix
    user = {
      isNormalUser = true;
      createHome = true;
      home = "/home";
    };

    users = {
      mutableUsers = false;
      extraUsers.root.initialHashedPassword = "!";
    };

    nix.settings.trusted-users = [cfg.username];
  };
}
