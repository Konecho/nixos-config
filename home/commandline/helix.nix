{pkgs, ...}: {
  # only avaliable in helix
  programs.helix.extraPackages = with pkgs; [
    fish-lsp
    just-lsp
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
      ];
    languages.language-server = {
      nixd = {
        command = with pkgs; "${lib.getExe nixd}";
        args = ["--semantic-tokens=true"];
        config.nixd = let
          getFlake = ''(builtins.getFlake (builtins.toString ./.))'';
        in {
          options = {
            home-manager.expr = ''${getFlake}.homeConfigurations.''${builtins.head(builtins.attrNames ${getFlake}.homeConfigurations)}.options'';
            nixos.expr = ''${getFlake}.nixosConfigurations.''${builtins.head(builtins.attrNames ${getFlake}.nixosConfigurations)}.options'';
          };
        };
      };
    };
    settings.editor.lsp = {
      display-messages = true;
      display-inlay-hints = true;
    };
    settings.keys.normal.backspace = let
      zr = c: ":run-shell-command zellij run " + c;
    in {
      b = zr "-f -- just build";
      f = zr "-fc -- broot";
      g = zr "-fc -- gitui";
      j = zr "-fc -- ${pkgs.lib.getExe pkgs.lazyjj}";
      r = zr "-f -- just run";
      t = zr "-f -- just test";
    };
  };
}
