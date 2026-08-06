{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    # 用仓库同 rev 内核（有二进制缓存）
    inputs.nix-cachyos-kernel.overlays.pinned

    # 基于 nixpkgs 版本构建可能版本不匹配/构建失败
    # inputs.nix-cachyos-kernel.overlays.default

    # 二选一
  ];
  boot.loader.grub = {
    efiSupport = true;
    #efiInstallAsRemovable = true; # canTouchEfiVariables 失效时用
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
