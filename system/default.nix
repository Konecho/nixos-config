{pkgs, ...}: {
  imports = [./network.nix ./locale.nix ./packages.nix ./boot.nix];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  environment.binsh = "${pkgs.dash}/bin/dash";

  hardware.pulseaudio.enable = true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  security.doas.enable = true;

  # To set up Sway using Home Manager, first you must enable Polkit in your nix configuration:
  # security.polkit.enable = true;
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
