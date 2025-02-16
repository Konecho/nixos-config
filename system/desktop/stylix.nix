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
    cursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-dark";
      size = 24;
    };
    fonts = let
      MAPLE = {
        package = pkgs.maple-mono-SC-NF;
        name = "Maple Mono SC NF";
      };
    in {
      monospace = MAPLE;
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
