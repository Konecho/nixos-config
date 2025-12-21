{
  pkgs,
  inputs,
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
    difftastic
    (
      writeShellScriptBin "noctalia-diff" ''
        difft ~/.config/noctalia/{settings,gui-settings}.json
      ''
    )
  ];

  programs.ghostty.settings.theme = "noctalia";
  programs.noctalia-shell = {
    enable = true;
    package = noctaliaPkgs;
    settings = {
      appLauncher = {
        terminalCommand = "ghostty -e";
        customLaunchPrefix = "niri msg action spawn --";
        customLaunchPrefixEnabled = true;
      };
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
      templates = {
        gtk = true;
        qt = true;
        ghostty = true;
        niri = true;
        vicinae = true;
        code = true;
      };
      general = {
        # avatarImage="";
      };
    };
    systemd.enable = true;
  };
  systemd.user.services.noctalia-shell.Service.Environment = [
    "QT_QPA_PLATFORM=wayland"
    "QT_QPA_PLATFORMTHEME=gtk3"
    "ELECTRON_OZONE_PLATFORM_HINT=auto"
  ];
  services.cliphist.enable = true;
  programs.niri.settings = let
    noctalia = cmd: ["noctalia-shell" "ipc" "call"] ++ (pkgs.lib.splitString " " cmd);
  in {
    spawn-at-startup = [{command = noctalia "wallpaper random";}];
    binds = {
      "Mod+Shift+L".action.spawn = noctalia "lockScreen lock";
      # "Mod+D".action.spawn = noctalia "launcher toggle";
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
}
