{pkgs, ...}: {
  ## dbus-run-session -- gnome-shell --wayland
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.gnome = {
    core-os-services.enable = true;
    core-shell.enable = true;
  };
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-console
      gnome-tour
      gedit # text editor
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-contacts
      gnome-maps
      gnome-weather
      simple-scan
      yelp
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
  environment.systemPackages = with pkgs.gnomeExtensions;
    [
      # appindicator
      # dash-to-panel
      # fly-pie
    ]
    ++ (with pkgs; [
      alacritty
      (writeScriptBin "xdg-terminal-exec" ''exec ${alacritty}/bin/alacritty -e "$@"'')
    ]);
  # services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  # services.gnome.gnome-settings-daemon.enable = true;
}
