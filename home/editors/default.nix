{...}: {
  imports = [
    # ./emacs.nix
    ./helix.nix
    # ./vim.nix
    ./vscode.nix
  ];
  home.sessionVariables.EDITOR = "hx";
  programs = {
    git = {
      enable = true;
      delta.enable = true;
      ignores = [
        "*~"
        "\\#*\\#"
        ".Trash-1000"
      ];
      userName = "NixOS";
      userEmail = "konecho@outlook.com";
    };
  };
}
