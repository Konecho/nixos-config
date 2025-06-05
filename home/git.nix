{...}: {
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
      userName = "NixOS";
      userEmail = "konecho@outlook.com";
      extraConfig.init.defaultBranch = "main";
      extraConfig.safe.directory = "/etc/nixos";
    };
    gitui = {
      enable = true;
    };

    # sudo git config --global --add safe.directory "$PWD"
  };
}
