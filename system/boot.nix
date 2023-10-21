{pkgs, ...}: {
  boot.loader = {
    systemd-boot = {
      enable = true;
      # consoleMode = "auto";
    };
    # efi.canTouchEfiVariables = true;
    # efi.efiSysMountPoint = "/boot/efi";
    # grub = {
    #   enable = true;
    #   efiSupport = true;
    #   device = "nodev";
    #   fsIdentifier = "label";
    #   # useOSProber = true;
    #   efiInstallAsRemovable = true;
    #   gfxmodeEfi = "1920x1080";
    #   # font = "${pkgs.hack-font}/share/fonts/hack/Hack-Regular.ttf";
    #   fontSize = 36;
    # };
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
