{
  pkgs,
  lib,
  ...
}: {
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions =
        [
          "appindicatorsupport@rgcjonas.gmail.com"
          "dash-to-panel@jderose9.github.com"
          "flypie@schneegans.github.com"
          "clipboard-indicator@tudmotu.com"
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
          "window-list"
          "windowsNavigator"
          "workspace-indicator"
        ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };
    "com/github/stunkymonkey/nautilus-open-any-terminal" = {terminal = "alacritty";};
  };
  home.packages = with pkgs.gnomeExtensions;
    [
      appindicator
      dash-to-panel
      clipboard-indicator
    ]
    ++ (with pkgs.gnome; [
      sushi
    ])
    ++ (with pkgs; [
      nautilus-open-any-terminal
    ]);
}
