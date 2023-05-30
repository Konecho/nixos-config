{pkgs, ...}: {
  home.packages = with pkgs; [
    # rustdesk
    # blender
    # gimp
    # godot
    # inkscape
    # krita

    microsoft-edge
    firefox
    # obsidian
    # libreoffice
    # onlyoffice-bin
    # thunderbird

    # android-studio
    scrcpy

    obs-studio
  ];
}
