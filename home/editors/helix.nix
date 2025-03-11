{pkgs, ...}: {
  home.sessionVariables.EDITOR = "hx";
  home.packages = with pkgs; [
    ## 非配置语言在自己项目的flake环境里开启
    nodePackages.bash-language-server
    yaml-language-server
    ruff # python
    vscode-langservers-extracted # css/html/json/markdown
    taplo # toml
    markdown-oxide
  ];
  programs.gitui.enable = true;
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings.editor = {
      cursorline = true;
      rulers = [120];
      cursor-shape = {
        insert = "bar";
      };
      bufferline = "multiple";
      statusline = {
        left = [
          "mode"
          "spinner"
          "version-control"
          "file-modification-indicator"
          "diagnostics"
        ];
        right = [
          "position"
          "primary-selection-length"
          "file-encoding"
          "file-line-ending"
          "file-type"
        ];
      };
      indent-guides = {
        # "▏", "┆", "┊", "⸽", "╎"
        character = "┊";
        render = true;
        skip-levels = 1;
      };
      auto-format = true;
    };
    languages.language = with pkgs;
      builtins.map (x: x // {auto-format = true;}) [
        {
          name = "nix";
          formatter = {
            command = "${alejandra}/bin/alejandra";
          };
          language-servers = ["nixd"];
        }
        {
          name = "python";
          formatter = {
            command = "${black}/bin/black";
          };
        }
        {
          name = "bash";
          formatter = {
            command = "${shfmt}/bin/shfmt";
          };
        }
        {
          name = "toml";
          formatter = {
            command = "${taplo}/bin/taplo fmt -";
          };
        }
        {
          name = "markdown";
          scope = "source.markdown";
          file-types = [
            "md"
            "markdown"
          ];
          # language-servers = ["rime-ls"];
        }
      ];
    languages.language-server = with pkgs; {
      nixd = {
        command = "${nixd}/bin/nixd";
        config.home-manager.expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.mei.options";
        config.nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.deskmini.options";
      };
      # rime-ls = {
      #   command = "${mypkgs.rime-ls}/bin/rime_ls";
      #   config.shared_data_dir = "${rime-data}/share/rime-data";
      #   config.user_data_dir = "~/.local/share/rime-ls";
      #   config.log_dir = "~/.local/share/rime-ls";
      #   config.max_candidates = 9;
      #   config.trigger_characters = [];
      #   config.schema_trigger_character = "&";
      #   config.max_tokens = 4;
      #   config.always_incomplete = true;
      # };
    };
    settings.editor.lsp = {
      display-messages = true;
      display-inlay-hints = true;
    };
    settings.keys.normal.backspace = {
      b = ":run-shell-command zellij run -f -- just build";
      f = ":run-shell-command zellij run -fc -- broot";
      g = ":run-shell-command zellij run -fc -- gitui";
      r = ":run-shell-command zellij run -f -- just run";
      t = ":run-shell-command zellij run -f -- just test";
    };
    # settings.theme = "monokai_pro_machine";
  };
}
