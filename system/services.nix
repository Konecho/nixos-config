{
  pkgs,
  username,
  lib,
  ...
}: {
  programs.adb.enable = true;
  users.groups.adbusers.members = [username];
  # hardware.pulseaudio.enable = lib.mkDefault false;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  services = {
    udisks2.enable = true;
    openssh.enable = true;
    fwupd.enable = true;
    # davfs2.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
    gpm.enable = true; # enables mouse support in virtual consoles.
    lanraragi.enable = true;
    lanraragi.package = pkgs.lanraragi.overrideAttrs (f: p: rec {
      postInstall = ''
        sed -i 's|Title|AlternateSeries|g' $out/share/lanraragi/lib/LANraragi/Plugin/Metadata/ComicInfo.pm
      '';
    });
    duplicati = {
      enable = true;
      dataDir = "/db/duplicati";
      parameters = ''
        --webservice-password=5112
      '';
    };
  };
}
