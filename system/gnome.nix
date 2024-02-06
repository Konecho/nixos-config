{pkgs, ...}: {
  ## dbus-run-session -- gnome-shell --wayland
  services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome = {
    core-os-services.enable = true;
    core-shell.enable = true;
  };
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gedit # text editor
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
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
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator

    gnomeExtensions.dash-to-panel
  ];
  # services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  # services.gnome.gnome-settings-daemon.enable = true;
}
