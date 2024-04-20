{
  inputs,
  pkgs,
  ...
}: {
  # imports = [inputs.niri.nixosModules.niri];
  # programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    niri
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };
}
