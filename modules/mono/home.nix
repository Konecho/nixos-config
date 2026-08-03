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
    email = mkOption {
      type = types.str;
      default = "alice@example.com";
      description = "Email of the single user.";
    };
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
