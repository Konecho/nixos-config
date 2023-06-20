{pkgs, ...}: {
  home.sessionVariables.BROWSER = "qutebrowser";
  home.packages = with pkgs; [
    rustdesk

    surf
    microsoft-edge
    firefox
    # hyper

    logseq

    # telegram-desktop
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
  programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser-qt6;
  };
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
}
