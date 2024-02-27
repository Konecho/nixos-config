# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod"];
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
    # "/thesis" = {
    #   device = "/dev/disk/by-label/btrfs";
    #   fsType = "btrfs";
    #   neededForBoot = false;
    #   options = btrfsops ++ ["subvol=@thesis"];
    # };
    "/backup" = {
      device = "/dev/disk/by-label/backup";
      fsType = "btrfs";
      # neededForBoot = false;
      options = ["defaults"];
    };
  };
  # fileSystems."/home" = {
  #   device = "/dev/disk/by-label/home";
  #   fsType = "ext4";
  # };
  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-label/nix";
  #   fsType = "ext4";
  #   neededForBoot = true;
  #   options = [ "noatime" ];
  # };
  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}