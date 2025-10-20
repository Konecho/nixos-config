{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./services.nix
    ./stylix.nix

    ./niri.nix
    ./niriswitcher.nix
    ./noctalia.nix
    # ./dank.nix
  ];
  # services.poweralertd.enable = true;
  home.packages = with pkgs; [
    libnotify
    sox
  ];
}
