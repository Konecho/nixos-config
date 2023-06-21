{
  pkgs,
  lib,
  config,
  ...
}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    # fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    # fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      # fcitx5-rime
      # rime-data
    ];
  };
  systemd.user.services.fcitx5-daemon.Service.ExecStart = lib.mkForce "${config.i18n.inputMethod.package}/bin/fcitx5 --keep";
}
