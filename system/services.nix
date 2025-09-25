{
  pkgs,
  username,
  lib,
  ...
}: {
  programs.adb.enable = true;
  users.groups.adbusers.members = [username];
  services = {
    udisks2.enable = true;
    openssh.enable = true;
    fwupd.enable = true;
    # davfs2.enable = true;
    gpm.enable = true; # enables mouse support in virtual consoles.
    lanraragi.enable = true;
    duplicati = {
      enable = true;
      dataDir = "/db/duplicati";
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
