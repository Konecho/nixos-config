{
  lib,
  config,
  ...
}: let
  HOME = config.home.homeDirectory;
in {
  home = {
    stateVersion = "25.11";
    sessionPath = ["${HOME}/.cargo/bin"];
    sessionVariables = {
      DOCKER_HOST = "unix:///run/docker.sock";
    };
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${HOME}/system/desktop";
    templates = "${HOME}/system/templates";
    publicShare = "${HOME}/system/public";
    documents = "${HOME}/documents";
    download = "${HOME}/downloads";
    music = "${HOME}/media/music";
    pictures = "${HOME}/media/photos";
    videos = "${HOME}/media/video";
  };
}
