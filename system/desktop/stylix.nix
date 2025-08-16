{
  pkgs,
  rootPath,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
    (rootPath + /home/stylix/wallpapers.nix)
  ];
  stylix = {
    enable = true;
    targets.grub.enable = false;
    cursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-dark";
      size = 24;
    };
    fonts = let
      MAPLE = {
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
      };
    in {
      monospace = MAPLE;
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
