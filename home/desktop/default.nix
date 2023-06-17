{pkgs, ...}: {
  imports = [./bars.nix ./fonts.nix ./theme.nix ./hyprland.nix ./dwl ./qtile];
  services.mako = {
    enable = true;
    # font = "monospace 12";
  };
  services.clipman.enable = true;
  home.packages = with pkgs; [
    ## [[app runner]]
    # kickoff
    # wofi
  ];
}
