{
  pkgs,
  lib,
  ...
}: {
  hardware.pulseaudio.enable = lib.mkDefault true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # boot.tmp = {
  #   useTmpfs = true;
  #   tmpfsSize = "95%";
  # };

  xdg.portal.config.common.default = "*";

  time.timeZone = "Asia/Shanghai";
  # time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "zh_CN.UTF-8";
  # i18n.defaultLocale = "en_US.UTF-8";

  # console.font = "Maple Mono SC NF";
}
