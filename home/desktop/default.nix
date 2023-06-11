{pkgs, ...}: {
  imports = [./bars.nix ./fonts.nix ./theme.nix ./hyprland.nix ./dwl];
  home.packages = with pkgs; [
    ## [[app runner]]
    kickoff
    # wofi
  ];
}
