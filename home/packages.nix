{ pkgs, config, lib, ... }:

# let maple-font = pkgs.callPackage ./maple-font.nix { }; in
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
  fonts.fontconfig.enable = true;
  gtk.font = {
    package = pkgs.maple-mono-SC-NF;
    name = "Maple Mono SC NF";
  };
  home.packages = with pkgs;
    [
      ## windows manager
      cardboard
      # swaybg
      # swaylock-effects
      kickoff
      wofi
      pamixer

      pavucontrol
      xdg-utils # xdg-open

      rustdesk
      # steam-tui
      # steamcmd
      # steam

      # blender
      # gimp
      # godot
      # inkscape
      # krita

      # microsoft-edge
      # obsidian
      # libreoffice
      # onlyoffice-bin
      firefox
      # thunderbird

      # android-studio
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
      socat # <echo 'cycle pause' | socat - /tmp/mpv-socket>
      # obs-studio


      ## programming
      conda
      ## rust-os-project
      rustup
      gcc
      qemu

      (
        let
          python-packages = python-packages: with python-packages; [
            # pandas
            pip
            autopep8
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

      neovide # WINIT_UNIX_BACKEND=x11 neovide
    ];

}
