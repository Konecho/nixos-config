{
  pkgs,
  lib,
  config,
  ...
}: {
  home.sessionVariables = {
    # QT_IM_MODULE = lib.mkForce "wayland";
    # GTK_IM_MODULE = "fcitx";
    # XMODIFIERS = "@im=fcitx5";
    SDL_IM_MODULE = "fcitx5";
    GLFW_IM_MODULE = "ibus";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    # fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    # fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      # fcitx5-rime
      # rime-data

      ## japanese
      fcitx5-anthy
      # fcitx5-mozc
    ];
  };
  systemd.user.services.fcitx5-daemon.Service.ExecStart = lib.mkForce "${config.i18n.inputMethod.package}/bin/fcitx5 --keep";
}
