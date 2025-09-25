{config, ...}: {
  programs.niriswitcher = {
    enable = true;
    settings = {
      keys = {
        modifier = "Mod";
        switch = {
          next = "Tab";
          prev = "Shift+Tab";
        };
      };
      center_on_focus = true;
      appearance = {
        system_theme = "dark";
        icon_size = 64;
      };
    };
  };
  programs.niri.settings.spawn-at-startup = [
    {command = ["niriswitcher"];}
  ];
  programs.niri.settings.binds = {
    "Mod+Tab" = ["niriswitcherctl" "show" "--window"];
    "Mod+Shift+Tab" = ["niriswitcherctl" "show" "--window"];
    "Mod+Grave" = ["niriswitcherctl" "show" "--workspace"];
    "Mod+Shift+Grave" = ["niriswitcherctl" "show" "--workspace"];
  };
}
