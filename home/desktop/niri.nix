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
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };
}
