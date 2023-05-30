{pkgs, ...}: {
  home.shellAliases.em = "emacs -nw";
  programs = {
    emacs = {
      enable = false;
      package = pkgs.emacs-nox;
      extraConfig = ''
        (setq standard-indent 2)
      '';
      extraPackages = epkgs: with epkgs; [nix-mode];
    };
    doom-emacs = {
      enable = false;
      doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el
      # and packages.el files
      # emacsPackage = pkgs.emacs-nox;
    };
  };
}
