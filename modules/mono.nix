{
  lib,
  config,
  username,
  ...
}: let
  inherit (lib) mkDefault mkIf mkOption types;
  cfg = config.mono;
in {
  options.mono.groupsAdd = mkOption {
    type = types.nullOr (types.listOf types.str);
    default = null;
    example = [
    ];
    description = ''
    '';
  };
  imports = [./alias.nix];
  config = {
    users.groups = builtins.listToAttrs (map (n: {
        name = n;
        value = {members = [username];};
      })
      cfg.groupsAdd);
  };
}
