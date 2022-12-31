{ pkgs, config, lib, ... }:

{
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "microsoft-edge-stable"
  #   "vscode"
  #   "obsidian"
  #   "unrar"
  #   "steamcmd"
  #   "steam"
  #   "steam-original"
  # ];
  home.packages = with pkgs;
    [
      # steam-tui
      # steamcmd
      # steam

      blender
      gimp
      godot
      inkscape
      # krita

      microsoft-edge
      obsidian
      libreoffice
      onlyoffice-bin
      # firefox
      # thunderbird

      scrcpy

      ## lib for <lf>
      unrar
      unzip
      p7zip # <7z>
      w3m
      poppler_utils # <pdftotext>
      highlight
      mediainfo

      ## multi-media
      wf-recorder
      ffmpeg
      yt-dlp
      mpv
      mpvpaper
      # obs-studio

      ## rust-os-project
      rustup
      gcc
      qemu

      (
        let
          python-packages = python-packages: with python-packages; [
            # pandas
            requests
          ];
          python-with-packages = python3.withPackages python-packages;
        in
        python-with-packages
      )

      ## terminal
      fd # find
      ripgrep # <rg> grep
      procs # ps

      just # make
      sd # sed
      du-dust # <dust> du

      ## Fonts
      monocraft

      imagemagick
      ueberzug
    ];

}