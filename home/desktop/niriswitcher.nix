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
    "Mod+Tab".action.spawn = ["niriswitcherctl" "show" "--window"];
    "Mod+Shift+Tab".action.spawn = ["niriswitcherctl" "show" "--window"];
    "Mod+Grave".action.spawn = ["niriswitcherctl" "show" "--workspace"];
    "Mod+Shift+Grave".action.spawn = ["niriswitcherctl" "show" "--workspace"];
  };
}
