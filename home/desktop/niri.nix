{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.niri-flake.homeModules.config
    ./niri-binds.nix
  ];
  home.packages = with pkgs; [
    inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  nixpkgs.overlays = [
    inputs.niri.overlays.default
    inputs.niri-flake.overlays.niri
  ];
  programs.niri.settings.xwayland-satellite = {
    enable = true;
    path = lib.getExe pkgs.xwayland-satellite-unstable;
  };
  programs.niri.settings = {
    environment = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland"; # gtk wayland
      QT_QPA_PLATFORM = "wayland"; # qt wayland
      MOZ_ENABLE_WAYLAND = "1"; # firefox / icecat
    };
    prefer-no-csd = true;
    screenshot-path = "${config.xdg.userDirs.pictures}/screenshots/niri %Y-%m-%d %H-%M-%S.png";
    window-rules = [
      {
        matches = [{title = "Xwayland";}];
        open-maximized = true;
      }
      {
        matches = [{app-id = "io.github.waylyrics.Waylyrics";}];
        open-floating = true;
        open-focused = false;
        border = {
          enable = false;
        };
        draw-border-with-background = false;
      }
      {
        matches = [
          {
            app-id = "wechat";
            title = "图片和视频";
          }
        ];
        open-floating = true;
      }
      {
        matches = [{app-id = "ghostty";}];
        draw-border-with-background = false;
      }
    ];
    input = {
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "20%";
      };
      keyboard.numlock = true;
    };
  };
}
