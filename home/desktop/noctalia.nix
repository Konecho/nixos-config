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
        widgets.left = [
          {
            id = "CustomButton";
            icon = "live-photo";
            leftClickExec = "systemctl --user restart linux-wallpaperengine.service";
          }
          {id = "Clock";}
          {
            id = "SystemMonitor";
            diskPath = "/nix";
          }
          {id = "ActiveWindow";}
          {id = "MediaMini";}
          {id = "WallpaperSelector";}
        ];
      };
      dock.displayMode = "auto_hide";
      colorSchemes = {
        darkMode = true;
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
  wayland.windowManager.niri.settings = let
    noctalia = cmd: ["noctalia-shell" "ipc" "call"] ++ (pkgs.lib.splitString " " cmd);
  in {
    binds = {
      "Mod+Shift+L".spawn = noctalia "lockScreen lock";
      # "Mod+D".spawn = noctalia "launcher toggle";
      "XF86AudioLowerVolume".spawn = noctalia "volume decrease";
      "XF86AudioRaiseVolume".spawn = noctalia "volume increase";
    };
    debug = {
      # Allows notification actions and window activation from Noctalia.
      honor-xdg-activation-with-invalid-serial = [];
    };
    layer-rule = [
      {
        match = {_props.namespace._raw = ''r#"^noctalia-overview*"#'';};
        place-within-backdrop = true;
      }
    ];
    # layout.background-color = "transparent";
    # overview.workspace-shadow.enable = false;
  };
}
