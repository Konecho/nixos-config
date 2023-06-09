{pkgs, ...}: {
  imports = [./bars.nix ./fonts.nix ./theme.nix ./hyprland.nix];
  home.packages = with pkgs; [
    ## [[app runner]]
    kickoff
    # wofi
  ];
}
