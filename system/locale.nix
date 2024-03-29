{pkgs, ...}: {
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  # time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
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

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   # fcitx.engines = with pkgs.fcitx-engines; [ rime ];
  #   # fcitx5.enableRimeData = true;
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-rime
  #   ];
  # };
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      #   noto-fonts
      #   noto-fonts-cjk
      #   noto-fonts-emoji
      #   # fira-code
      #   # fira-code-symbols
      #   # (nerdfonts.override {
      #   #   fonts = [
      #   #     # "FiraCode"
      #   #     # "UbuntuMono"
      #   #     # "Noto"
      #   #   ];
      #   # })
      #   # sarasa-gothic #更纱黑体
      #   # source-code-pro
      #   # hack-font
      #   # jetbrains-mono
      wqy_zenhei
    ];
    # fontconfig = {
    #   enable = true;
    #   defaultFonts = {
    #     emoji = ["Noto Color Emoji"];
    #     monospace = [
    #       "Noto Sans Mono CJK SC"
    #       # "DejaVu Sans Mono"
    #     ];
    #     sansSerif = [
    #       "Noto Sans CJK SC"
    #       # "Source Han Sans SC"
    #     ];
    #     serif = [
    #       "Noto Serif CJK SC"
    #       # "Source Han Serif SC"
    #     ];
    #   };
    # };
  };
}
