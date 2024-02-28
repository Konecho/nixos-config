{
  pkgs,
  config,
  inputs,
  ...
}: let
  asztal = pkgs.callPackage (inputs.asztal + /ags) {inherit inputs;};
in {
  imports = [(inputs.asztal + /nixos/hyprland.nix)];
  services = {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };
  };
  services.greetd = {
    enable = true;
    settings.default_session.command = pkgs.writeShellScript "greeter" ''
      export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
      export XCURSOR_THEME=Qogir
      ${asztal}/bin/greeter
    '';
  };
  environment.systemPackages = with pkgs; [
    qogir-icon-theme
    morewaita-icon-theme
    gnome.adwaita-icon-theme
  ];
}
