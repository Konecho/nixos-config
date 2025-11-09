{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  timestamp = inputs.nixpkgs.lastModified;
  mctime =
    lib.readFile (pkgs.runCommand "mctimestamp" {}
      "date -d @${builtins.toString timestamp} '+%d/%m/%Y, %I:%M %p' |tr -d '\n' > $out");
in {
  imports = [
    inputs.minegrub-theme.nixosModules.default
    inputs.minegrub-world-sel-theme.nixosModules.default
    # inputs.minesddm.nixosModules.default
  ];
  nixpkgs.overlays = [
    inputs.minecraft-plymouth-theme.overlay
  ];
  boot.loader.grub = {
    configurationLimit = 30;
    minegrub-theme = {
      # enable = true;
      splash = "100% Flakes!";
      background = "background_options/1.8  - [Classic Minecraft].png";
      boot-options-count = 4;
    };
    minegrub-world-sel = {
      enable = true;
      customIcons = [
        {
          name = "nixos";
          lineTop = "NixOS (${mctime})";
          lineBottom = "Survival Mode, No Cheats, Version: ${config.system.nixos.release}";
          # Icon: you can use an icon from the remote repo, or load from a local file
          imgName = "nixos";
          # customImg = builtins.path {
          #   path = ./nixos-logo.png;
          #   name = "nixos-img";
          # };
        }
      ];
    };
  };
  boot.plymouth = {
    enable = true;
    theme = "mc";
    themePackages = [
      pkgs.plymouth-minecraft-theme
    ];
  };
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
  ];
  # stylix = {
  #   targets.grub.enable = false;
  #   targets.plymouth.enable = false;
  # };
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    theme = "minesddm";
  };
  environment.systemPackages = with pkgs; [
    inputs.minesddm.packages.${pkgs.stdenv.hostPlatform.system}.default
    qt5.qtbase
    qt5.qtquickcontrols2
    qt5.qtgraphicaleffects

    kdePackages.layer-shell-qt
  ];

  services.upower.enable = true;
}
