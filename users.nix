{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" ];
    packages = with pkgs; [
      blender
      gimp
      godot
      inkscape
      # krita

      chezmoi
      disfetch
      ranger

      firefox
      microsoft-edge
      obsidian
      libreoffice
      onlyoffice-bin
      # obs-studio
      # thunderbird

      scrcpy
      vscode
      w3m

      ## rust-os-project
      rustup
      gcc
      python310Full
      just
      qemu
      fd
    ];
  };

  home-manager.users.mei = { pkgs, ... }: {
    home = {
      stateVersion = "22.11";
      sessionPath = [ "$HOME/.cargo/bin" ];
      sessionVariables = { TERMINAL = "kitty"; };
      # packages = [ pkgs.atool pkgs.httpie ];
    };
    # xdg.userDirs = {
    #   enable = true;
    #   createDirectories = true;
    # };
    programs = {
      bash = {
        enable = true;
        # profileExtra = ""; 
      };
      bottom.enable = true;
      lsd = { enable = true; enableAliases = true; };
      git = {
        enable = true;
        userName = "NixOS";
        userEmail = "me@meiro.top";
      };
      kitty = {
        enable = true;
        font = {
          size = 12;
          name = "FiraCode Nerd Font";
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
  };
}
