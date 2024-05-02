{
  pkgs,
  lib,
  ...
}: {
  programs = {
    adb.enable = true;
  };
  services = {
    udisks2.enable = true;
    openssh.enable = true;
    fwupd.enable = true;
    # davfs2.enable = true;
    duplicati = {
      enable = true;
      dataDir = "/db/duplicati";
    };
    kmscon = {
      enable = true;
      hwRender = true;
      fonts = [
        {
          package = pkgs.maple-mono-SC-NF;
          name = "Maple Mono SC NF";
        }
      ];
      extraOptions = "--term xterm-256color";
      extraConfig = "font-size=15";
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
