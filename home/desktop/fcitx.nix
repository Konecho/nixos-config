{pkgs, ...}: let
  fcitx5Package = pkgs.libsForQt5.fcitx5-with-addons.override {
    addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-gtk
      # fcitx5-rime
      # rime-data

      fcitx5-chinese-addons
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-minecraft

      ## japanese
      fcitx5-anthy
      # fcitx5-mozc
    ];
  };
in {
  home.packages = [
    fcitx5Package
  ];
  home.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    QT_PLUGIN_PATH = "${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}";
  };
}
