{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.niri.homeModules.config];
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  programs.niri.settings = null;
  home.packages = with pkgs; [
  ];
  programs.fuzzel.enable = true;
  services.mako.enable = true;
  programs.waybar = {
    enable = true;
    # settings.mainBar.layer = "top";
    systemd.enable = true;
  };
}
