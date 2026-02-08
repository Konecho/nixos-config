{
  config,
  lib,
  modulesPath,
  rootPath,
  inputs,
  ...
}: let
  username = config.mono.username;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (rootPath + "/disko-config.nix")
    inputs.disko.nixosModules.default
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
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
    # "/tmp".neededForBoot = true;
    # "/swap".neededForBoot = true;
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024; # 16 GB
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # for steam to run
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
