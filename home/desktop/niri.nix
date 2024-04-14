{
  inputs,
  pkgs,
  ...
}: {
  # imports = [inputs.niri.homeModules.config];
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  # programs.niri.settings = null;
  home.packages = with pkgs; [
    niri
    cage

    nwg-wrapper
    pokemonsay
    fortune
    ansifilter
    disfetch
  ];
  programs.fuzzel.enable = true;
  services.mako.enable = true;
  # programs.waybar = {
  #   enable = true;
  #   # settings.mainBar.layer = "top";
  #   systemd.enable = true;
  # };
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };
  systemd.user.services.nwg-widget = {
    Unit = {
      Description = "";
    };
    Install = {
      WantedBy = ["niri.service"];
      Wants = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.nwg-wrapper}/bin/nwg-wrapper -s /etc/nixos/home/desktop/nwg-widget.py -r 60000 -p right -mr 200";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
