{pkgs, ...}: {
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions =
        [
          "appindicatorsupport@rgcjonas.gmail.com"
          # "dash-to-panel@jderose9.github.com"
          "flypie@schneegans.github.com"
          "clipboard-indicator@tudmotu.com"
          # "paperwm@paperwm.github.com"
          "blur-my-shell@aunetx"
          "dash-to-dock@micxgx.gmail.com"
          "desktop-cube@schneegans.github.com"
          "panel-date-format@keiii.github.com"
        ]
        ++ builtins.map (appName: appName + "@gnome-shell-extensions.gcampax.github.com") [
          "apps-menu"
          "auto-move-windows"
          "drive-menu"
          "launch-new-instance"
          "native-window-placement"
          "places-menu"
          "screenshot-window-sizer"
          "user-theme"
          # "window-list"
          "windowsNavigator"
          "workspace-indicator"
          "places-menu"
        ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };
    "org/gnome/shell/extensions/paperwm" = {
      show-window-position-bar = false;
      # Press Alt + F2, type lg and press enter. In the top-right panel select "Windows".
      winprops = [
        ''{"wm_class":"io.poly000.waylyrics","scratch_layer":true}''
      ];
    };
    "com/github/stunkymonkey/nautilus-open-any-terminal" = {
      terminal = "alacritty";
    };
    # "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
    #   blur = true;
    # };
    "org/gnome/shell/extensions/dash-to-dock" = {
      transparency-mode = "DYNAMIC";
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      whitelist = [
        "Alacritty"
        "org.gnome.Extensions"
        "org.gnome.Shells.Extensions"
        "org.gnome.nautilus"
      ];
    };
  };
  home.packages =
    (with pkgs.gnomeExtensions; [
      appindicator
      dash-to-panel
      clipboard-indicator
      paperwm
      appindicator
      dash-to-panel
      fly-pie
      blur-my-shell

      desktop-cube
      dash-to-dock
      hide-top-bar #
      panel-date-format
    ])
    ++ (with pkgs.gnome; [
      sushi
    ])
    ++ (with pkgs; [
      gnome-menus
      nautilus-open-any-terminal
    ]);
}
