# <home-manager switch --flake .#mei>
# <nix run nixpkgs#nyancat> #disfetch #neofetch #hyfetch
{
  pkgs,
  config,
  ...
}: {
  imports = [./nix.nix ./desktop ./music.nix ./editors ./gui.nix ./terminals.nix ./shells.nix ./cli.nix ./tui.nix];
  home = {
    stateVersion = "22.11";
    # username = "${username}";
    homeDirectory = "/home/${config.home.username}";
    sessionPath = ["$HOME/.cargo/bin"];
    sessionVariables = {
      DOCKER_HOST = "unix:///run/docker.sock";
      # SWWW_TRANSITION_FPS = 60;
      # SWWW_TRANSITION_STEP = 2;
      # SWWW_TRANSITION_TYPE = "random";
      # XDG_CACHE_HOME = "${home.homeDirectory}/.cache";
    };
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    # fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    # fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      # fcitx5-rime
      # rime-data
    ];
  };
  # xdg.cacheHome = "${home.homeDirectory}/.cache";
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
