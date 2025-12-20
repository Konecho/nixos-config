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
  options.mono.email = mkOption {
    type = types.str;
    default = "alice@example.com";
    description = "";
  };
  config = {
    home.homeDirectory = "/home";
    home.username = cfg.username;
    programs.git.settings.user = {
      name = cfg.username;
      email = cfg.email;
    };
    programs.jujutsu.settings.user = {
      name = cfg.username;
      email = cfg.email;
    };
  };
}
