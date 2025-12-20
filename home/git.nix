{pkgs, ...}: {
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
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };
    delta.enable = true;
    delta.enableGitIntegration = true;
    gitui.enable = true;
    jujutsu.enable = true;
    gh.enable = true;
    gh.extensions = with pkgs; [gh-dash];
  };
}
