{pkgs, ...}: {
  imports = [./commandline/pkm-shell.nix];
  home.sessionVariables.BROWSER = "qutebrowser";
  home.packages = with pkgs; [
    # rustdesk
    # motrix
    # clash-verge-rev
    clash-nyanpasu

    # czkawka # duplicates
    # logseq

    # surf
    # microsoft-edge
    # google-chrome
    # vivaldi
    firefox
    # firefox-devedition
    librewolf

    # hyper

    telegram-desktop
    # element-desktop-wayland # matrix
    # kotatogram-desktop-with-webkit

    qt6.qtwayland
    hydrus
    ## sometime need an middle version for conversion
    # (hydrus.overrideAttrs (f: p: rec {
    #   version = "558";
    #   src = fetchFromGitHub {
    #     owner = "hydrusnetwork";
    #     repo = "hydrus";
    #     rev = "refs/tags/v${version}";
    #     hash = "sha256-qVoA8IZYLUJ6Li/M8ORjkfntc06oMVD7739F79sFLjM=";
    #   };
    # }))
    # android-studio
  ];
  programs = {
    qutebrowser.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
    zathura.enable = true; # pdf viewer
    # pidgin = {
    #   enable = true;
    #   plugins = with pkgs; [purple-matrix purple-discord];
    # };
  };
}
