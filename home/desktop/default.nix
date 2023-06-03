{pkgs, ...}: {
  imports = [./bars.nix ./fonts.nix ./theme.nix ./wallpapers.nix ./hyprland.nix];
  home.packages = with pkgs; [
    ## [[app runner]]
    kickoff
    # wofi
  ];
}
