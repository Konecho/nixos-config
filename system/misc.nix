{
  pkgs,
  lib,
  ...
}: {
  hardware.pulseaudio.enable = lib.mkDefault true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "95%";
  };

  xdg.portal.config.common.default = "*";
}
