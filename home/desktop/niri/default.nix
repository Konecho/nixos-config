{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.niri-nix.homeModules.default
    ./spawn-at-startup.nix
    ./window-rule.nix
    ./binds.nix
    ./blur.nix
  ];

  wayland.windowManager.niri.enable = true;
  wayland.windowManager.niri.package = lib.mkDefault pkgs.niri;
  wayland.windowManager.niri.systemd.variables = ["--all"];
  wayland.windowManager.niri.settings = {
    environment = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland"; # gtk wayland
      QT_QPA_PLATFORM = "wayland"; # qt wayland
      MOZ_ENABLE_WAYLAND = "1"; # firefox / icecat
    };
    prefer-no-csd = true;
    screenshot-path = "${config.xdg.userDirs.pictures}/screenshots/niri %Y-%m-%d %H-%M-%S.png";
    input = {
      _children = [{focus-follows-mouse._props.max-scroll-amount = "20%";}];
      keyboard.numlock = true;
    };
  };
}
