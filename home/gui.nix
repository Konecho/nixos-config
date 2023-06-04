{pkgs, ...}: {
  home.packages = with pkgs; [
    rustdesk
    # blender
    # gimp
    # godot
    # inkscape
    # krita
    surf
    etcher
    telegram-desktop

    microsoft-edge
    firefox
    # obsidian
    # libreoffice
    # onlyoffice-bin
    # thunderbird

    # android-studio
    scrcpy

    # obs-studio
  ];
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
}
