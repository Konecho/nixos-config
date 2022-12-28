{ pkgs, ... }:

with pkgs;
[
  blender
  gimp
  godot
  inkscape
  # krita

  # firefox
  microsoft-edge
  obsidian
  libreoffice
  onlyoffice-bin
  # obs-studio
  # thunderbird

  scrcpy
  # vscode
  w3m
  unrar
  poppler_utils # <pdftotext>

  # chezmoi
  # ranger
  # ffmpeg

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

  fd # find
  ripgrep # <rg> grep
  procs # ps

  just # make
  sd # sed
  du-dust # <dust> du
]

