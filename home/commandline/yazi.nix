{
  pkgs,
  inputs,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "lf";
    settings = {
      manager = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };
    plugins = let
      yazi-plugins = inputs.yazi-plugins;
      yazi-starship = inputs.yazi-starship;
    in {
      chmod = "${yazi-plugins}/chmod.yazi";
      full-border = "${yazi-plugins}/full-border.yazi";
      max-preview = "${yazi-plugins}/max-preview.yazi";
      git = "${yazi-plugins}/git.yazi";
      smart-filter = "${yazi-plugins}/smart-filter.yazi";
      starship = yazi-starship;
    };

    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
      require("git"):setup()
    '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = "T";
          run = "plugin max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "F";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
      ];
    };
  };
}
