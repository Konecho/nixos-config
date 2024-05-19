{pkgs, ...}: {
  time.timeZone = "Asia/Shanghai";
  # time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "zh_CN.UTF-8";
  # i18n.defaultLocale = "en_US.UTF-8";

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      wqy_zenhei
    ];
  };
}
