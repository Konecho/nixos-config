{pkgs, ...}: {
  imports = [
    # ./ly.nix
    ./niri.nix
    # ./cosmic.nix
    # ./stylix.nix
  ];
  # programs.regreet.enable = true;
  # services.greetd.enable = true;
}
