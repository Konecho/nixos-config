{
  disko.devices = let
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
    disk.main = {
      type = "disk";
      # 仅接管挂载，不做分区操作
      device = "/dev/disk/by-label/nixos";

      content = {
        type = "btrfs";
        subvolumes = {
          "/boot" = {
            # 原配置：
            # device = "/dev/disk/by-uuid/4944-6404";
            # fsType = "vfat";
            #
            # disko 不在 existing/btrfs 中管理 vfat，
            # /boot EFI 分区请单独保留 fileSystems 或单独一个 disko disk
          };

          "@nix" = {
            mountpoint = "/nix";
            mountOptions = btrfsops;
          };

          "@gnu" = {
            mountpoint = "/gnu";
            mountOptions = btrfsops;
          };

          "@persist" = {
            mountpoint = "/persist";
            mountOptions = btrfsops;
          };

          "@db" = {
            mountpoint = "/db";
            mountOptions = btrfsops;
          };

          "@tmp" = {
            mountpoint = "/tmp";
            mountOptions = btrfsops;
          };

          "@swap" = {
            mountpoint = "/swap";
            mountOptions = [
              "noatime"
              "compress=none"
              "discard=async"
            ];
          };
        };
      };
    };
    # disk.backup = {
    # };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
        "defaults"
        "mode=755"
      ];
    };
  };
}
