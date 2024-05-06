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
        language-servers = ["nixd"];
      }
      {
        name = "python";
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
    languages.language-server = {
      nixd = {
        command = "${pkgs.nixd}/bin/nixd";
        config.home-manager.expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.mei.options";
        config.nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.deskmini.options";
      };
      rime-ls = {
        command = "${pkgs.mypkgs.rime-ls}/bin/rime_ls";
        config.shared_data_dir = "${pkgs.rime-data}/share/rime-data";
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
