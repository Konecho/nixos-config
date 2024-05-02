{pkgs, ...}: {
  boot.loader = {
    grub.efiSupport = true;
    grub.device = "nodev";
    efi.canTouchEfiVariables = true;
  };

  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
