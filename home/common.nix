# <home-manager switch --flake .#mei>
{
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    stateVersion = "22.11";
    homeDirectory = lib.mkDefault "/home";
    sessionPath = ["$HOME/.cargo/bin"];
    sessionVariables = {
      DOCKER_HOST = "unix:///run/docker.sock";
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
