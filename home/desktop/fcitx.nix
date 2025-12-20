{pkgs, ...}: let
in {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
      # fcitx5-rime
      # rime-data

      fcitx5-pinyin-moegirl
      fcitx5-pinyin-minecraft

      ## japanese
      fcitx5-anthy
      # fcitx5-mozc
    ];
    fcitx5.waylandFrontend = true;
  };
  programs.niri.settings.spawn-at-startup = [
    {command = ["fcitx5" "-r" "-d"];}
  ];
}
