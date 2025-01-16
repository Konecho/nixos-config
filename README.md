# NixOS

![wallpaper](https://pbs.twimg.com/media/GhYgRg8aQAAuh6n.jpg)

## 目录结构

- `home`,`system`: 主电脑的home-manager配置与系统配置
- `hosts`: 不同主机的个性化配置，通过`imports`copy一部分主电脑配置
- `home`,`system`去掉`default.nix`以防止不小心全引用，若需要，用scanPath
- `data`: 脚本文件

## 磁盘迁移

- 格式化磁盘
  - `lsblk`
  - `ls /dev/disk/by-label/`
  - `sudo cfdisk /dev/nvme1n1`
  - `sudo mkfs.btrfs -f /dev/nvme1n1p2 -R free-space-tree -L btrfs`

- 修改hardware-configuration.nix，将挂载目标改为新磁盘标号
  - `sudo nixos-rebuild boot`
  - 这一步需要先做，使得生成的启动配置能移动到新磁盘

- 挂载目标btrfs卷
  - `sudo mkdir /mnt`
  - `sudo mount -t btrfs -o defaults,ssd,nosuid,nodev,compress=zstd,noatime /dev/disk/by-label/backup /mnt/`

- 创建子卷
  - `sudo btrfs subvolume create /mnt/@nix`
  - `sudo btrfs subvolume create /mnt/@persist`
  - `sudo btrfs subvolume sync /mnt`

- 复制内容到新子卷
  - `sudo rsync -ah -A -X --info=progress2 /nix/ /mnt/@nix/`
  - `sudo rsync -ah -A -X --info=progress2 /persist/ /mnt/@persist/`
