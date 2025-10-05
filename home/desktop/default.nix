{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./services.nix

    ./niri.nix
    ./noctalia.nix
  ];
  # services.poweralertd.enable = true;
  home.packages = with pkgs; [
    libnotify
    sox
  ];
}
