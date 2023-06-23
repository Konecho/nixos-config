{
  pkgs,
  lib,
  ...
}: {
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

  hardware.pulseaudio.enable = lib.mkDefault true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "95%";
  };

  security.doas.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault "22.11"; # Did you read the comment?
}
