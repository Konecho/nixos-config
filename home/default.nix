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
  };
  home = {
    stateVersion = "22.11";
    shellAliases = { em = "emacs"; };
    # username = "${username}";
    homeDirectory = "/home/${config.home.username}";
    sessionPath = [ "$HOME/.cargo/bin" ];
    sessionVariables = { TERMINAL = "alacritty"; };
  };

  imports = [ ./wayland.nix ./music.nix ./editors.nix ./packages.nix ];

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
  gtk = {
    enable = true;
    cursorTheme = { name = "Vanilla-DMZ"; package = pkgs.vanilla-dmz; };
    theme = {
      name = "Pop";
      package = pkgs.pop-gtk-theme;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-solarized-gtk-theme;
    };
  };
  programs = {
    home-manager.enable = true;
    starship = { enable = true; };
    navi.enable = true;
    bat.enable = true; # cat
    tealdeer.enable = true; # <tldr>
    tealdeer.settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates = {
        auto_update = true;
      };
    };
    zellij.enable = true; # tmux
    zoxide.enable = true; # <z> cd
    bottom.enable = true; # <btm> top
    mcfly.enable = true; # <ctrl-r>
    broot.enable = true; # <br> tree-view search
    lsd = { enable = true; enableAliases = true; }; # ls
    bash = {
      enable = true;
      # profileExtra = ""; 
      historyIgnore = [ "l" "ls" "z" "cd" "exit" ];
    };
    lf = {
      enable = true;
      previewer = {
        keybinding = "i";
        source = pkgs.writeShellScript "pv.sh" ''
          #!/bin/sh
          case "$1" in
              *.tar*) tar tf "$1";;
              *.zip) unzip -l "$1";;
              *.rar) unrar l "$1";;
              *.7z) 7z l "$1";;
              *.pdf) pdftotext "$1" -;;
              *.mp3|*.avi|*.mp4|*.webm|*.mkv|*.flv|*.mov|*.mpg|*.wmv|*.ogg) mediainfo "$1";;
              *) highlight -O ansi "$1" || cat "$1";;
          esac
        '';
      };
    };
  };
}
