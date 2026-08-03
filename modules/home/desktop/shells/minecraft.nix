{
  config,
  lib,
  pkgs,
  ...
}: let
  devCfgPath = "/home/srcs/dotfiles-minecraft-style/dotfiles/.config/quickshell";
in {
  imports = [];
  # nixpkgs.overlays = [inputs.quickshell.overlays.default];
  home.packages = with pkgs; [
    libnotify
    sox
    quickshell
    iwd # iwctl
    pulseaudio # pactl
    brightnessctl
  ];
  programs.niri.settings.binds = let
    qs = cmd:
      ["qs" "-p" devCfgPath "ipc" "call"]
      ++ (pkgs.lib.splitString " " cmd);
  in {
    "Mod+Escape".action.spawn = qs "settings toggle";
    "Mod+D".action.spawn = qs "launcher open";
    "Mod+Shift+L".action.spawn = qs "pause lock";
  };
  # journalctl --user -u minecraft-shell -f --no-pager
  systemd.user.services.minecraft-shell = {
    Unit = {
      Description = "";
      After = [config.wayland.systemd.target];
      PartOf = [config.wayland.systemd.target];
      StartLimitIntervalSec = 60;
      StartLimitBurst = 3;
    };
    Service = {
      Type = "exec";
      ExecStart = "${lib.getExe pkgs.quickshell} -p ${devCfgPath}";
      Restart = "on-failure";
      RestartSec = 3;
      TimeoutStartSec = 10;
      TimeoutStopSec = 5;
      WorkingDirectory = devCfgPath;
      Environment = [
        "TERM=xterm-256color"
        "QT_QPA_PLATFORM=wayland"
        "QT_QPA_PLATFORMTHEME=gtk3"
        "ELECTRON_OZONE_PLATFORM_HINT=auto"
      ];
      Slice = "session.slice";
    };
    Install = {
      WantedBy = [config.wayland.systemd.target];
    };
  };
}
