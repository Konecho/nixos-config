# deskmini 主机入口（blueprint 约定：hosts/<hostname>/configuration.nix）
# 共享系统模块按需从 flake.modules.nixos.* 导入（原 scanPath ./system 的全部，vm.nix 除外）
{flake, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../disko-raid.nix
    flake.modules.nixos.user
    flake.modules.nixos.age
    flake.modules.nixos.backup
    flake.modules.nixos.boot
    flake.modules.nixos.core
    flake.modules.nixos.guix
    flake.modules.nixos.home-merge
    flake.modules.nixos.lix
    flake.modules.nixos.minecraft
    flake.modules.nixos.network
    flake.modules.nixos.niri
    flake.modules.nixos.nix
    flake.modules.nixos.services
    flake.modules.nixos.tmpfs-as-root
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "deskmini";
}
