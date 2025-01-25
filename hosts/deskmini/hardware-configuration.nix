{
  config,
  lib,
  modulesPath,
  username,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  fileSystems = let
    # https://archive.kernel.org/oldwiki/btrfs.wiki.kernel.org/index.php/FAQ.html#Can_I_mount_subvolumes_with_different_mount_options.3F
    btrfsops = [
      "noatime"
      "defaults"
      "nodev"
      "nosuid"
      "rw"
      # ^:generic v:specific
      "autodefrag"
      "compress=zstd"
      "space_cache=v2"
      "ssd"
    ];
  in {
    "/boot" = {
      device = "/dev/disk/by-uuid/4944-6404";
      fsType = "vfat";
      # device = "/dev/disk/by-label/nixos";
      # fsType = "btrfs";
      # neededForBoot = true;
      # options = btrfsops ++ ["subvol=@boot"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = btrfsops ++ ["subvol=@nix"];
    };
    "/gnu" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = btrfsops ++ ["subvol=@gnu"];
    };
    "/persist" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = btrfsops ++ ["subvol=@persist"];
    };
    "/db" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = btrfsops ++ ["subvol=@db"];
    };
    "/tmp" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      neededForBoot = true;
      options = btrfsops ++ ["subvol=@tmp"];
    };
    # "/backup" = {
    #   device = "/dev/disk/by-label/backup";
    #   fsType = "btrfs";
    #   # neededForBoot = false;
    #   options = ["defaults"];
    # };
    "/backup" = {
      device = "/dev/disk/by-uuid/1E86F54E4D9F5874";
      fsType = "ntfs-3g";
      neededForBoot = false;
      options = [
        "rw"
        "uid=${username}"
      ];
    };
  };
  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
