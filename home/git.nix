{pkgs, ...}: let
  email = "konecho@outlook.com";
  name = "NixOS";
in {
  programs = {
    git = {
      enable = true;
      signing.format = "openpgp";
      ignores = [
        "*~"
        "\\#*\\#"
        ".Trash-1000"
        "*\\__pycache__"
        ".direnv"
      ];
      settings = {
        user = {
          inherit email name;
        };
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };
    delta.enable = true;
    delta.enableGitIntegration = true;
    gitui = {
      enable = true;
    };
    jujutsu = {
      enable = true;
      settings.user = {
        inherit email name;
      };
    };
    gh = {
      enable = true;
      extensions = with pkgs; [gh-dash];
    };
    # sudo git config --global --add safe.directory "$PWD"
  };
}
