# nvchad broken
# 若想继续配置，参考：
# https://github.com/search?q=repo%3Aazuwis%2Fnix-config%20nvchad&type=code
{pkgs, ...}: {
  home.shellAliases.neovide = "WINIT_UNIX_BACKEND=x11 ${pkgs.neovide}/bin/neovide";
  # home.packages = with pkgs; [
  #   neovide # WINIT_UNIX_BACKEND=x11 neovide
  # ];
  programs.neovim = {
    enable = true;
    coc.enable = true;
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
    # extraLuaConfig = ''
    #   dofile("${pkgs.vimPlugins.nvchad}/init.lua")
    # '';
    plugins = with pkgs.vimPlugins; [
      # cmp-buffer
      # cmp-nvim-lsp
      # cmp-nvim-lua
      # cmp-path
      # cmp_luasnip
      # comment-nvim
      # friendly-snippets
      # gitsigns-nvim
      # indent-blankline-nvim
      # luasnip
      # nvchad-extensions
      # nvchad-ui
      # nvim-autopairs
      # nvim-cmp
      # nvim-colorizer-lua
      # nvim-lspconfig
      # nvim-tree-lua
      # nvim-treesitter
      # nvim-web-devicons
      # nvterm
      # telescope-nvim
      # which-key-nvim
      # base46 # https://github.com/nvchad/base46/
      # nvterm # https://github.com/nvchad/nvterm/
      # nvchad-extensions # https://github.com/nvchad/extensions/
      # nvchad-ui # https://github.com/nvchad/ui/
      # nvchad # https://github.com/nvchad/nvchad/
      vim-nix
      rainbow
      {
        plugin = indentLine;
        config = ''
          let g:indent_guides_guide_size=1
          let g:indent_guides_start_level=2
        '';
      }
      {
        plugin = vim-monokai;
        config = "colo monokai";
      }
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
  stylix.targets.vim.enable = false;
}
