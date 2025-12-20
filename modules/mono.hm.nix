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
  config = {
    home.homeDirectory = "/home";
    home.username = cfg.username;
  };
}
