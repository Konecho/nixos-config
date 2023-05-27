{ pkgs, config, lib, ... }:

rec {
  home.shellAliases.em = "emacs -nw";
  home.shellAliases.neovide = "WINIT_UNIX_BACKEND=x11 neovide";
  home.activation.symlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "-------------------------------------------------------------"
    echo "------------ START MANUAL IDEMPOTENT SECTION ----------------"
    echo "-------------------------------------------------------------"
    homedir=${config.home.homeDirectory}
    echo "****** homedir=$homedir"

    echo
    echo "------ symlinks ----"

    symlink() {
      local src="$1"
      local dest="$2"
      [[ -e "$src" ]] && {
          [[ -e $dest ]] && {
              echo "****** OK: $dest exists"
          } || {
              $DRY_RUN_CMD ln -s "$src" "$dest" || {
                  echo "****** ERROR: could not symlink $src to $dest"
              }
              echo "****** CHANGED: $dest updated"
          }
      } || {
          echo "****** ERROR: source $src does not exist"
      }
    }

    symlink "$homedir/.vscode/extensions" \
            "$homedir/.vscode-oss/extensions"
    symlink "$homedir/.config/Code/User/settings.json" \
            "$homedir/.config/VSCodium/User/settings.json"

    echo "-------------------------------------------------------------"
    echo "------------ END MANUAL IDEMPOTENT SECTION ----------------"
    echo "-------------------------------------------------------------"
  '';

  programs = {
    git = {
      enable = true;
      delta.enable = true;
      ignores = [
        "*~"
        "\\#*\\#"
      ];
      userName = "NixOS";
      userEmail = "me@meiro.top";
    };
    # emacs = {
    #   enable = true;
    #   package = pkgs.emacs-nox;
    #   extraConfig = ''
    #     (setq standard-indent 2)
    #   '';
    #   extraPackages = epkgs: with epkgs;[ nix-mode ];
    # };
    doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el
      # and packages.el files
      # emacsPackage = pkgs.emacs-nox;
    };
    helix.enable = true;
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      # enableUpdateCheck = false;
      # userSettings = {
      #   "workbench.colorTheme" = "Default Light+";
      #   "nix.enableLanguageServer" = true;
      #   "editor.fontFamily" = "'FiraCode Nerd Font'";
      #   "git.enableSmartCommit" = true;
      #   "git.autofetch" = true;
      #   "git.confirmSync" = false;
      #   "explorer.excludeGitIgnore" = true;
      #   "files.autoSave" = "on";
      #   "editor.formatOnSave" = true;
      # };
      # extensions = with pkgs.vscode-extensions; [ ms-ceintl.vscode-language-pack-zh-hans ];
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
