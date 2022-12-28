# <home-manager switch --flake .#mei> 
# <nix run nixpkgs#nyancat> #disfetch #neofetch #hyfetch
{ pkgs, config, ... }:

rec {

  home = let userspkgs = import ./packages.nix pkgs; in
    {
      stateVersion = "22.11";
      # username = "${username}";
      homeDirectory = "/home/${config.home.username}";
      sessionPath = [ "$HOME/.cargo/bin" ];
      sessionVariables = { TERMINAL = "kitty"; XDG_CURRENT_DESKTOP = "Unity"; };
      packages = with pkgs; [ libappindicator-gtk3 ] ++ userspkgs;
    };

  imports = [ ./wayland.nix ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    # fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    # fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
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
    git = {
      enable = true;
      userName = "NixOS";
      userEmail = "me@meiro.top";
    };
    vscode = {
      enable = true;
      enableUpdateCheck = false;
      userSettings = {
        "workbench.colorTheme" = "Default Light+";
        "nix.enableLanguageServer" = true;
        "editor.fontFamily" = "'FiraCode Nerd Font'";
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
      };
      extensions = with pkgs.vscode-extensions; [ ms-ceintl.vscode-language-pack-zh-hans ];
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
              *) highlight -O ansi "$1" || cat "$1";;
          esac
        '';
      };
    };
    neovim = {
      enable = true;
      coc = { enable = true; };
      vimAlias = true;
      extraConfig = ''
        syntax on
        set showmatch
        set nu
        set backspace=2
        set ruler
        set mouse=a
        set tabstop=4
        set helplang=cn
        set encoding=utf-8
        if exists("g:neovide")
          set guifont=Fira_Code_Nerd_Font,Noto_Sans_Mono_CJK_SC:h14
          set guifont=Noto_Sans_Mono_CJK_SC:h14
          let g:neovide_transparency = 0.8
          let g:neovide_cursor_vfx_mode = "pixiedust"
          let g:neovide_cursor_vfx_mode = "sonicboom"
        endif
      '';
      plugins = with pkgs.vimPlugins; [
        vim-nix
        rainbow
        {
          plugin = indentLine;
          config = ''
            let g:indent_guides_guide_size=1
            let g:indent_guides_start_level=2
          '';
        }
        { plugin = vim-monokai; config = "colo monokai"; }
        vim-airline-themes
        {
          plugin = vim-airline;
          config = ''
            let g:airline_theme = 'desertink'
            let g:airline#extensions#keymap#enabled = 1
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#left_alt_sep = '|'
            let g:airline#extensions#tabline#formatter = 'default'
            let g:airline#extensions#tabline#buffer_nr_show = 0
            let g:airline#extensions#tabline#buffer_idx_mode = 1
            let g:airline#extensions#tabline#buffer_idx_format = {
                \ '0': '0 ', '1': '1 ', '2': '2 ', '3': '3 ', '4': '4 ',
                \ '5': '5 ', '6': '6 ', '7': '7 ', '8': '8 ', '9': '9 '}
            if !exists('g:airline_symbols')
                let g:airline_symbols = {}
            endif
            let g:airline_symbols.linenr = 'CL'
            let g:airline_symbols.whitespace = '|'
            let g:airline_symbols.maxlinenr = 'Ml'
            let g:airline_symbols.branch = 'BR'
            let g:airline_symbols.readonly = 'RO'
            let g:airline_symbols.dirty = 'DT'
            let g:airline_symbols.crypt = 'CR' 
          '';
        }
      ];
    };
  };
}
