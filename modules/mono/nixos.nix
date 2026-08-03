{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.mono;
in {
  options.mono = {
    enable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Enable mono single-user enforcement.";
    };
    username = mkOption {
      type = types.str;
      default = "alice";
      example = "bob";
      description = "The single user of the system.";
    };
    groupsAdd = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = [];
      description = "Extra groups the single user is a member of.";
    };
  };

  # `user.*` → `users.users.<username>.*`
  imports = [
    (lib.modules.mkAliasOptionModule ["user"] ["users" "users" cfg.username])
  ];

  config = {
    users.groups = builtins.listToAttrs (map (n: {
        name = n;
        value = {members = [cfg.username];};
      })
      cfg.groupsAdd);

    # alias user to users.users.<name> above
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
