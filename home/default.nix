# <home-manager switch --flake .#mei>
{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./desktop
    ./editors

    ./cli.nix
    ./games.nix
    ./gpg.nix
    ./gui.nix
    ./music.nix
    ./nix.nix
    ./programming.nix
    ./shells.nix
    ./stylix.nix
    ./terminals.nix
    ./tui.nix
  ];
  home = {
    stateVersion = "22.11";
    homeDirectory = "/home/${config.home.username}";
    sessionPath = ["$HOME/.cargo/bin"];
    sessionVariables = {
      DOCKER_HOST = "unix:///run/docker.sock";
      # gtk wayland
      # GDK_BACKEND = "x11";
      GDK_BACKEND = "wayland";
      # qt wayland
      QT_QPA_PLATFORM = "wayland";
      # firefox / icecat
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/system/desktop";
    download = "$HOME/downloads";
    templates = "$HOME/system/templates";
    publicShare = "$HOME/system/public";
    documents = "$HOME/documents";
    music = "$HOME/media/music";
    pictures = "$HOME/media/photos";
    videos = "$HOME/media/video";
  };
}
