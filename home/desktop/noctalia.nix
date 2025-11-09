{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  noctaliaPkgs =
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];
  home.packages = with pkgs; [
    noctaliaPkgs
    jq
    colordiff
    (
      writeShellScriptBin "noctalia-diff" ''
        diff -u <(jq -S . ~/.config/noctalia/settings.json) <(jq -S . ~/.config/noctalia/gui-settings.json) | colordiff
      ''
    )
  ];
  programs.noctalia-shell = {
    enable = true;
    settings = {
      appLauncher.terminalCommand = "ghostty -e";
      bar = {
        density = "comfortable";
        floating = true;
        widgets.center = [{id = "Workspace";} {id = "WallpaperSelector";}];
      };
      dock.displayMode = "auto_hide";
      colorSchemes = {
        darkMode = false;
        useWallpaperColors = true;
      };
      screenRecorder = {
        directory = "${config.xdg.userDirs.videos}/noctalia";
        videoSource = "screen";
      };
      wallpaper = {
        directory = "${config.xdg.userDirs.pictures}/wallpapers";
        randomEnabled = true;
        overviewEnabled = true;
        panelPosition = "top_center";
      };
      general = {};
      hooks.enabled = true;
      # fd -e jpg -e png -E '*.blur' -x magick {} -blur 0x8 {}.blur
      setupCompleted = true;
    };
  };
  systemd.user.services = {
    "noctalia-shell" = {
      Unit = {
        Description = "Noctalia Shell - Wayland desktop shell";
        After = [config.wayland.systemd.target];
        PartOf = [config.wayland.systemd.target];
        StartLimitIntervalSec = 60;
        StartLimitBurst = 3;
      };
      Service = {
        Type = "exec";
        ExecStart = "${lib.getExe noctaliaPkgs}";
        Restart = "on-failure";
        RestartSec = 3;
        TimeoutStartSec = 10;
        TimeoutStopSec = 5;
        Environment = [
          "QT_QPA_PLATFORM=wayland"
          "QT_QPA_PLATFORMTHEME=gtk3"
          "ELECTRON_OZONE_PLATFORM_HINT=auto"
          "NOCTALIA_SETTINGS_FALLBACK=%h/.config/noctalia/gui-settings.json"
        ];
        Slice = "session.slice";
      };
      Install = {
        WantedBy = [config.wayland.systemd.target];
      };
    };
  };

  services.cliphist.enable = true;
  programs.fuzzel.enable = true;
  programs = {
    niri = {
      settings = let
        noctalia = cmd: ["noctalia-shell" "ipc" "call"] ++ (pkgs.lib.splitString " " cmd);
      in {
        spawn-at-startup = [{command = noctalia "wallpaper random";}];
        binds = {
          "Mod+Shift+L".action.spawn = noctalia "lockScreen lock";
          "Mod+D".action.spawn = noctalia "launcher toggle";
          "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
          "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
          "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
        };
        window-rules = [
          {
            # Rounded corners for a modern look.
            geometry-corner-radius = {
              bottom-left = 20.0;
              bottom-right = 20.0;
              top-left = 20.0;
              top-right = 20.0;
            };
            # Clips window contents to the rounded corner boundaries.
            clip-to-geometry = true;
          }
        ];
        debug = {
          # Allows notification actions and window activation from Noctalia.
          honor-xdg-activation-with-invalid-serial = [];
        };
        layer-rules = [
          {
            matches = [{namespace = "^noctalia-overview*";}];
            place-within-backdrop = true;
          }
        ];
        # layout.background-color = "transparent";
        # overview.workspace-shadow.enable = false;
      };
    };
  };
}
