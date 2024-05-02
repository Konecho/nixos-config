{pkgs, ...}: {
  time.timeZone = "Asia/Shanghai";
  # time.hardwareClockInLocalTime = true;

  i18n.supportedLocales = ["zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];
  i18n.defaultLocale = "zh_CN.UTF-8";
  # i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    # LC_NUMERIC = "zh_CN.UTF-8";
    # LC_TIME = "zh_CN.UTF-8";
  };
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
