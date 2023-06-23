{pkgs, ...}: {
  home.sessionVariables.BROWSER = "qutebrowser";
  home.packages = with pkgs; [
    # rustdesk

    surf
    microsoft-edge
    firefox
    # hyper

    logseq

    # telegram-desktop
    # element-desktop-wayland # matrix
    kotatogram-desktop-with-webkit

    # blender
    # gimp
    # godot
    # inkscape
    # krita
    # etcher

    # nur.repos.xddxdd.wechat-uos

    # obsidian
    # libreoffice
    # onlyoffice-bin

    # thunderbird

    # android-studio
    # scrcpy
  ];
  programs = {
    qutebrowser = {
      enable = true;
      package = pkgs.qutebrowser-qt6;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };
    # pidgin = {
    #   enable = true;
    #   plugins = with pkgs; [purple-matrix purple-discord];
    # };
  };
}
