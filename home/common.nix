{lib, ...}: let
  HOME = "/home";
in {
  home = {
    stateVersion = "22.11";
    homeDirectory = lib.mkDefault HOME;
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
