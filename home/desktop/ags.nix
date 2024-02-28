{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    (inputs.asztal + /home-manager/hyprland.nix)
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    (pkgs.callPackage (inputs.asztal + /ags) {inherit inputs;})
    bun
    dart-sass
    fd
    brightnessctl
    swww
    inputs.matugen.packages.${system}.default
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];

  programs.ags = {
    enable = true;
    configDir = inputs.asztal + /ags;
    # extraPackages = with pkgs; [
    #   accountsservice
    # ];
  };
}
