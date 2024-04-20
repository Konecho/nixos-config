{pkgs, ...}: {
  home.sessionVariables.BROWSER = "qutebrowser";
  home.packages = with pkgs; [
    # rustdesk
    motrix
    obsidian

    # surf
    # microsoft-edge
    google-chrome
    # vivaldi
    firefox
    # firefox-devedition
    librewolf
    # hyper
    czkawka # duplicates

    # logseq

    # telegram-desktop
    # element-desktop-wayland # matrix
    kotatogram-desktop-with-webkit

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

    # blender
    # gimp
    # godot
    # inkscape
    # krita
    # etcher

    # nur.repos.xddxdd.wechat-uos

    # obsidian
    # libreoffice-qt
    # onlyoffice-bin

    # thunderbird

    # android-studio
    # scrcpy
  ];
  programs = {
    qutebrowser = {
      enable = true;
      # package = pkgs.qutebrowser-qt6;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
    # pidgin = {
    #   enable = true;
    #   plugins = with pkgs; [purple-matrix purple-discord];
    # };
  };
}
