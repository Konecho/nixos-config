{pkgs, ...}: {
  programs.helix.extraPackages = with pkgs; [
    bash-language-server
    yaml-language-server
    ruff # python
    vscode-langservers-extracted # css/html/json/markdown
    taplo # toml
    marksman
    markdown-oxide
    shellcheck
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
      color-modes = true;
      end-of-line-diagnostics = "hint";
      inline-diagnostics = {other-lines = "error";};
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
            command = "${lib.getExe alejandra}";
          };
          language-servers = ["nixd"];
        }
        {
          name = "python";
          formatter = {
            command = "${lib.getExe ruff}";
            args = ["format" "--line-length" "120" "-"];
          };
        }
        {
          name = "toml";
          formatter = {
            command = "${lib.getExe taplo}";
            args = ["fmt" "-"];
          };
        }
        {
          name = "markdown";
          scope = "source.markdown";
          file-types = [
            "md"
            "markdown"
          ];
        }
      ];
    languages.language-server = with pkgs; {
      nixd = let
        userName = "mei";
        hostName = "deskmini";
      in {
        command = "${lib.getExe nixd}";
        config.home-manager.expr = ''(builtins.getFlake "/etc/nixos").homeConfigurations.${userName}.options'';
        config.nixos.expr = ''(builtins.getFlake "/etc/nixos").nixosConfigurations.${hostName}.options'';
      };
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
  };
}
