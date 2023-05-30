{pkgs, ...}: {
  imports = [./bars.nix ./fonts.nix ./theme.nix ./wallpapers.nix];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
  home.packages = with pkgs; [
    ## [[app runner]]
    kickoff
    # wofi
  ];
}
