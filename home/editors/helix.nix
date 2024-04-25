{pkgs, ...}: {
  home.sessionVariables.EDITOR = "hx";
  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages.language = [
      {
        name = "nix";
        formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
        auto-format = true;
      }
      {
        name = "bash";
        formatter = {command = "${pkgs.shfmt}/bin/shfmt";};
        auto-format = true;
      }
      {
        name = "toml";
        formatter = {command = "${pkgs.taplo}/bin/taplo fmt -";};
        auto-format = true;
      }
      {
        name = "rust";
        auto-format = true;
      }
      {
        name = "markdown";
        scope = "source.markdown";
        file-types = ["md" "markdown"];
        language-servers = ["rime-ls"];
      }
    ];
    languages.language-server.rime-ls = {
      command = "${pkgs.mypkgs.rime-ls}/bin/rime_ls";
      config.shared_data_dir = "/usr/share/rime-data";
      config.user_data_dir = "~/.local/share/rime-ls";
      config.log_dir = "~/.local/share/rime-ls";
      config.max_candidates = 9;
      config.trigger_characters = [];
      config.schema_trigger_character = "&";
      config.max_tokens = 4;
      config.always_incomplete = true;
    };

    settings.editor.lsp = {
      display-messages = true;
      display-inlay-hints = true;
    };
    settings.theme = "github_light";
    themes = {
      base16 = let
        transparent = "none";
        gray = "#665c54";
        dark-gray = "#3c3836";
        white = "#fbf1c7";
        black = "#282828";
        red = "#fb4934";
        green = "#b8bb26";
        yellow = "#fabd2f";
        orange = "#fe8019";
        blue = "#83a598";
        magenta = "#d3869b";
        cyan = "#8ec07c";
      in {
        "ui.menu" = transparent;
        "ui.menu.selected" = {modifiers = ["reversed"];};
        "ui.linenr" = {
          fg = gray;
          bg = dark-gray;
        };
        "ui.popup" = {modifiers = ["reversed"];};
        "ui.linenr.selected" = {
          fg = white;
          bg = black;
          modifiers = ["bold"];
        };
        "ui.selection" = {
          fg = black;
          bg = blue;
        };
        "ui.selection.primary" = {modifiers = ["reversed"];};
        "comment" = {fg = gray;};
        "ui.statusline" = {
          fg = white;
          bg = dark-gray;
        };
        "ui.statusline.inactive" = {
          fg = dark-gray;
          bg = white;
        };
        "ui.help" = {
          fg = dark-gray;
          bg = white;
        };
        "ui.cursor" = {modifiers = ["reversed"];};
        "variable" = red;
        "variable.builtin" = orange;
        "constant.numeric" = orange;
        "constant" = orange;
        "attributes" = yellow;
        "type" = yellow;
        "ui.cursor.match" = {
          fg = yellow;
          modifiers = ["underlined"];
        };
        "string" = green;
        "variable.other.member" = red;
        "constant.character.escape" = cyan;
        "function" = blue;
        "constructor" = blue;
        "special" = blue;
        "keyword" = magenta;
        "label" = magenta;
        "namespace" = blue;
        "diff.plus" = green;
        "diff.delta" = yellow;
        "diff.minus" = red;
        "diagnostic" = {modifiers = ["underlined"];};
        "ui.gutter" = {bg = black;};
        "info" = blue;
        "hint" = dark-gray;
        "debug" = dark-gray;
        "warning" = yellow;
        "error" = red;
      };
    };
  };
}
