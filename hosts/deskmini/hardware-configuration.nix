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
    (rootPath + "/disko-raid.nix")
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
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/4944-6404";
      fsType = "vfat";
    };
  };
  boot.loader.efi.efiSysMountPoint = "/boot";
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
