{pkgs, ...}: {
  # boot.loader.grub = {
  #   efiSupport = true;
  #   device = "nodev";
  #   # configurationLimit = 8;
  # };
  # boot.loader.systemd-boot = {
  #   enable = true;
  #   configurationLimit = 16;
  # };
  boot.loader.grub = {
    efiSupport = true;
    #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
    useOSProber = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
