{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    # Use the exact kernel versions as defined in this repo.
    # Guarantees you have binary cache.
    inputs.nix-cachyos-kernel.overlays.pinned

    # Alternatively, build the kernels on top of nixpkgs version in your flake.
    # This might cause version mismatch/build failures!
    # inputs.nix-cachyos-kernel.overlays.default

    # Only use one of the two overlays!
  ];
  boot.loader.grub = {
    efiSupport = true;
    #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
    useOSProber = true;
    device = "nodev";
  };
  boot.extraModprobeConfig = ''
    options btusb disable_autosuspend=1
  '';
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
