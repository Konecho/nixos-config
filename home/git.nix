{pkgs, ...}: let
  email = "konecho@outlook.com";
  name = "NixOS";
in {
  programs = {
    git = {
      enable = true;
      delta.enable = true;
      ignores = [
        "*~"
        "\\#*\\#"
        ".Trash-1000"
        "*\\__pycache__"
        ".direnv"
      ];
      userName = name;
      userEmail = email;
      extraConfig.init.defaultBranch = "main";
      extraConfig.safe.directory = "/etc/nixos";
    };
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
