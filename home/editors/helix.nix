{pkgs, ...}: {
  home.sessionVariables.EDITOR = "hx";
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
        left = ["mode" "version-control" "file-modification-indicator" "diagnostics" "spinner"];
        right = ["position" "primary-selection-length" "file-encoding" "file-line-ending" "file-type"];
      };
      indent-guides = {
        # "▏", "┆", "┊", "⸽", "╎"
        character = "╎";
        render = true;
        skip-levels = 1;
      };
      auto-format = true;
    };
    languages.language = with pkgs; [
      {
        name = "nix";
        formatter = {command = "${alejandra}/bin/alejandra";};
        language-servers = ["nixd"];
      }
      {
        name = "python";
        formatter = {command = "${black}/bin/black";};
      }
      {
        name = "bash";
        formatter = {command = "${shfmt}/bin/shfmt";};
      }
      {
        name = "toml";
        formatter = {command = "${taplo}/bin/taplo fmt -";};
      }
      {
        name = "markdown";
        scope = "source.markdown";
        file-types = ["md" "markdown"];
        language-servers = ["rime-ls"];
      }
    ];
    languages.language-server = with pkgs; {
      nixd = {
        command = "${nixd}/bin/nixd";
        config.home-manager.expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.mei.options";
        config.nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.deskmini.options";
      };
      rime-ls = {
        command = "${mypkgs.rime-ls}/bin/rime_ls";
        config.shared_data_dir = "${rime-data}/share/rime-data";
        config.user_data_dir = "~/.local/share/rime-ls";
        config.log_dir = "~/.local/share/rime-ls";
        config.max_candidates = 9;
        config.trigger_characters = [];
        config.schema_trigger_character = "&";
        config.max_tokens = 4;
        config.always_incomplete = true;
      };
    };
    settings.editor.lsp = {
      display-messages = true;
      display-inlay-hints = true;
    };
    settings.theme = "github_light";
  };
}
