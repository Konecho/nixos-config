{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.minegrub-theme.nixosModules.default
  ];
  nixpkgs.overlays = [
    inputs.minecraft-plymouth-theme.overlay
  ];
  boot.loader.grub = {
    configurationLimit = 30;
    minegrub-theme = {
      enable = true;
      splash = "100% Flakes!";
      background = "background_options/1.8  - [Classic Minecraft].png";
      boot-options-count = 4;
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
  stylix = {
    targets.grub.enable = false;
    targets.plymouth.enable = false;
  };
}
