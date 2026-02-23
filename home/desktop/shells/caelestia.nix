{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.caelestia.homeManagerModules.default
  ];
  programs.caelestia = {
    enable = true;
    # cli.enable = true;
    settings = {
      bar.status = {
        showBattery = false;
      };
      bar.tray.background = false;
      paths.wallpaperDir = "${config.xdg.userDirs.pictures}/wallpapers";
    };
    systemd.environment = [
      "QT_QPA_PLATFORMTHEME=gtk3"
    ];
  };
  wayland.windowManager.niri.settings.binds = let
    caelestia = cmd: ["caelestia-shell" "ipc" "call"] ++ (pkgs.lib.splitString " " cmd);
  in {
    "Mod+Shift+L".spawn = caelestia "lock lock";
    "Mod+Shift+D".spawn = caelestia "drawers toggle launcher";
  };
}
