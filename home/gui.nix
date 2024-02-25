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
    # firefox-devedition
    librewolf
    # hyper
    czkawka # duplicates

    # logseq

    # telegram-desktop
    # element-desktop-wayland # matrix
    kotatogram-desktop-with-webkit

    (hydrus.overrideAttrs (f: p: rec {
      version = "544";
      src = fetchFromGitHub {
        owner = "hydrusnetwork";
        repo = "hydrus";
        rev = "refs/tags/v${version}";
        hash = "sha256-e3VvkdJAQx5heKDJ1Ms6XpXrXWdzv48f8yu0DHfPy1A=";
      };
      buildInputs = p.buildInputs ++ [pkgs.qt6.qtwayland];
      # buildPhase = ''
      #   mv hydrus_client.py client.py
      #   mv hydrus_server.py server.py
      # '';
    }))

    # blender
    # gimp
    # godot
    # inkscape
    # krita
    # etcher

    # nur.repos.xddxdd.wechat-uos

    # obsidian
    # libreoffice-qt
    onlyoffice-bin

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
