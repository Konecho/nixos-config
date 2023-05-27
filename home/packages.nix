{ pkgs, config, lib, ... }:

# let maple-font = pkgs.callPackage ./maple-font.nix { }; in
{
  fonts.fontconfig.enable = true;
  gtk.font = {
    package = pkgs.maple-mono-SC-NF;
    name = "Maple Mono SC NF";
  };
  home.packages = with pkgs;
    [
      ## [[nix]]
      nix-init
      rnix-lsp
      nil


      ## [[tui]]
      vtm
      sc-im
      mc
      calc


      ## [[desktop]]
      # cardboard # windows manager
      mypkgs.pokemon-terminal
      mypkgs.shox
      mypkgs.scutthesis.fonts.windows
      mypkgs.scutthesis.thesis

      swww
      kickoff
      # swaybg
      # swaylock-effects
      # wofi

      # steam-tui
      # steamcmd
      # steam


      ## [[productivity]]
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


      ## [[multi-media]]
      xdg-utils # <xdg-open>
      pamixer
      pavucontrol
      wf-recorder
      ffmpeg
      yt-dlp
      mpv
      mpvpaper
      socat # <echo 'cycle pause' | socat - /tmp/mpv-socket>
      obs-studio


      ## [[programming]]
      # conda
      rustup
      gcc
      qemu

      (
        let
          python-packages = python-packages: with python-packages; [
            # pandas
            pip
            python-lsp-server
            autopep8
            requests
          ];
          python-with-packages = python3.withPackages python-packages;
        in
        python-with-packages
      )

      ## [[lsp]]
      nodePackages.bash-language-server
      cmake-language-server
      rust-analyzer
      texlab


      ## [[terminal]]
      zscroll
      wget
      fd # find
      fzf
      ripgrep # <rg> grep
      procs # ps
      comma # , <command>

      jq
      just # make
      sd # sed
      du-dust # <dust> du
      gdu

      imagemagick
      # ueberzug

      ## lib for <lf>
      # unrar
      # unzip
      # p7zip # <7z>
      # w3m
      # poppler_utils # <pdftotext>
      # highlight
      # mediainfo
      # chafa
      # timg


      ## [[Fonts]]
      monocraft
      nur.repos.vanilla.Win10_LTSC_2021_fonts
      # nur.repos.vanilla.apple-fonts.NY

      neovide # WINIT_UNIX_BACKEND=x11 neovide

    ];

}
