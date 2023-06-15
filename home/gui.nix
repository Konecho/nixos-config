{pkgs, ...}: {
  home.packages = with pkgs; [
    rustdesk
    # blender
    # gimp
    # godot
    # inkscape
    # krita
    # etcher

    # [[web browser]]
    surf
    microsoft-edge
    firefox

    telegram-desktop
    # nur.repos.xddxdd.wechat-uos

    # obsidian
    logseq
    # libreoffice
    # onlyoffice-bin

    # thunderbird

    # android-studio
    # scrcpy
  ];
  programs.qutebrowser.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
}
