{ pkgs, ... }:

{
  "mei" = with pkgs;
    [
      blender
      gimp
      godot
      inkscape
      # krita

      firefox
      microsoft-edge
      obsidian
      libreoffice
      onlyoffice-bin
      # obs-studio
      # thunderbird

      scrcpy
      vscode
      w3m
      nyancat

      # chezmoi
      # ranger
      # ffmpeg

      ## rust-os-project
      rustup
      gcc
      python310Full
      qemu

      just # make
      fd # find
      procs # ps
      sd # sed
      du-dust # <dust> du
      ripgrep # <rg> grep
    ];
}

