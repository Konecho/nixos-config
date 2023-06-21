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
    ./terminals

    ./cli.nix
    ./common.nix
    ./games.nix
    ./git.nix
    ./gpg.nix
    ./gui.nix
    ./music.nix
    ./nix.nix
    ./programming.nix
    ./shells.nix
    # ./stylix.nix
    ./tui.nix
  ];
  nix.package = pkgs.nix; # not common
  home = {
    stateVersion = "22.11";
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
}
