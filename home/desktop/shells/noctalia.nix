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
    json-diff
    jq
    (
      writeShellScriptBin "noctalia-diff" ''
        # difft ~/.config/noctalia/{settings,gui-settings}.json
        json-diff <(jq -S . ~/.config/noctalia/settings.json) <(noctalia-shell ipc call state all | jq -S .settings)
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
      ui = {
        panelBackgroundOpacity = 0.6;
        translucentWidgets = true;
      };
      notifications.backgroundOpacity = 0.7;
      bar = {
        density = "comfortable";
        floating = true;
        capsuleOpacity = 0.5;
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
        # darkMode = true;
        useWallpaperColors = true;
      };
      wallpaper = {
        directory = "${config.xdg.userDirs.pictures}/wallpapers";
        automationEnabled = true;
        overviewEnabled = true;
        panelPosition = "top_center";
      };
      templates.activeTemplates =
        map (id: {
          enabled = true;
          inherit id;
        }) [
          "gtk"
          "qt"
          "ghostty"
          "niri"
          "vicinae"
          "code"
        ];
      general = {
        avatarImage = "/home/cover.png";
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
      "Mod+Shift+L" = {
        _props.hotkey-overlay-title = "Lock Screen";
        spawn = noctalia "lockScreen lock";
      };
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
    include = ["noctalia.kdl"];
    # layout.background-color = "transparent";
    # overview.workspace-shadow.enable = false;
  };
}
