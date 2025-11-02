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
      paths.wallpaperDir = "${config.xdg.userDirs.pictures}/wallpapers";
    };
    systemd.environment = [
      "QT_QPA_PLATFORMTHEME=gtk3"
    ];
  };
  programs = {
    niri = {
      settings = let
        caelestia = cmd: ["caelestia-shell" "ipc" "call"] ++ (pkgs.lib.splitString " " cmd);
      in {
        binds = {
          "Mod+Shift+L".action.spawn = caelestia "lock lock";
          "Mod+D".action.spawn = caelestia "drawers toggle launcher";
        };
      };
    };
  };
}
