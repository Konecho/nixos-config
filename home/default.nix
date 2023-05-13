# <home-manager switch --flake .#mei> 
# <nix run nixpkgs#nyancat> #disfetch #neofetch #hyfetch
{ pkgs, config, ... }:

rec {
  nix.package = pkgs.nix;
  nix.settings.tarball-ttl = 43200;
  nix.registry = {
    n = {
      # flake = pkgs;
      from = {
        id = "n";
        type = "indirect";
      };
      to = {
        owner = "NixOS";
        ref = "nixpkgs-unstable";
        repo = "nixpkgs";
        type = "github";
      };
    };
    m = {
      # flake = pkgs;
      from = {
        id = "m";
        type = "indirect";
      };
      to = {
        owner = "Konecho";
        ref = "master";
        repo = "my-nixpkgs";
        type = "github";
      };
    };
  };
  home = rec {
    stateVersion = "22.11";
    # username = "${username}";
    homeDirectory = "/home/${config.home.username}";
    sessionPath = [ "$HOME/.cargo/bin" ];
    sessionVariables = {
      TERMINAL = "alacritty";
      DOCKER_HOST = "unix:///run/docker.sock";
      # SWWW_TRANSITION_FPS = 60;
      # SWWW_TRANSITION_STEP = 2;
      # SWWW_TRANSITION_TYPE = "random";
      # XDG_CACHE_HOME = "${home.homeDirectory}/.cache";
    };
  };

  imports = [ ./desktop.nix ./music.nix ./editors.nix ./packages.nix ];

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
  programs = {
    home-manager.enable = true;

    starship.enable = true;
    navi.enable = true;
    bat.enable = true; # cat
    zellij.enable = true; # tmux
    zoxide.enable = true; # <z> cd
    bottom.enable = true; # <btm> top
    mcfly.enable = true; # <ctrl-r>
    broot.enable = true; # <br> tree-view search 

    # ls
    lsd = {
      enable = true;
      enableAliases = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    # <tldr>
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };
    bash = {
      enable = true;
      # profileExtra = ""; 
      historyIgnore = [ "l" "ls" "z" "cd" "exit" ];
    };
    fish = {
      enable = true;
      loginShellInit = ''
        # Fish syntax highlighting
        set -g fish_color_autosuggestion '555'  'brblack'
        set -g fish_color_cancel -r
        set -g fish_color_command --bold
        set -g fish_color_comment red
        set -g fish_color_cwd green
        set -g fish_color_cwd_root red
        set -g fish_color_end brmagenta
        set -g fish_color_error brred
        set -g fish_color_escape 'bryellow'  '--bold'
        set -g fish_color_history_current --bold
        set -g fish_color_host normal
        set -g fish_color_match --background=brblue
        set -g fish_color_normal normal
        set -g fish_color_operator bryellow
        set -g fish_color_param cyan
        set -g fish_color_quote yellow
        set -g fish_color_redirection brblue
        set -g fish_color_search_match 'bryellow'  '--background=brblack'
        set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
        set -g fish_color_user brgreen
        set -g fish_color_valid_path --underline      
      '';
    };
    lf = {
      enable = true;
      previewer = {
        keybinding = "i";
        source = "${pkgs.ctpv}/bin/ctpv";
      };
    };
  };
}
