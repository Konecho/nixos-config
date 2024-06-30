{
  pkgs,
  lib,
  ...
}: {
  programs.adb.enable = true;

  services = {
    udisks2.enable = true;
    openssh.enable = true;
    fwupd.enable = true;
    # davfs2.enable = true;
    duplicati = {
      enable = true;
      dataDir = "/db/duplicati";
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
