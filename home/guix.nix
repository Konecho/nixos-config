{
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    sessionPath = ["$HOME/.cargo/bin"];
    sessionVariables = {
      GUIX_PROFILE = "$HOME/.guix-profile";
    };
  };
  xdg.configFile = {
    "guix/channels.scm" = {
      text = ''
        (list (channel
                 (inherit (car %default-channels))
                 (url "https://mirror.sjtu.edu.cn/git/guix.git")))
      '';
    };
  };
  programs.helix.languages.language = [
    {
      name = "scheme";
      language-servers = ["guile-lsp-server"];
    }
  ];
  programs.helix.languages.language-server.guile-lsp-server = {
    command = "guile-lsp-server";
  };
  programs.fish.interactiveShellInit = lib.mkAfter ''
    fenv source "$GUIX_PROFILE/etc/profile"  > /dev/null
  '';
}
