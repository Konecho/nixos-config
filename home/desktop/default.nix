{pkgs, ...}: {
  imports = [./bars.nix ./fonts.nix ./theme.nix ./hyprland.nix ./dwl];
  services.mako = {
    enable = true;
    # font = "monospace 12";
  };
  home.packages = with pkgs; [
    ## [[app runner]]
    kickoff
    # wofi
  ];
}
