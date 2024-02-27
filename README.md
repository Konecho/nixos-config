## 结构

- `home`,`system`: 主电脑的home-manager配置与系统配置
- `hosts`: 不同主机的个性化配置，通过`imports`copy一部分主电脑配置
- `home`,`system`去掉`default.nix`以防止不小心全引用，用scanPath以排除法进行全引用
- 

## 对比

```
cd /nix/var/nix/profiles
nix-diff $(nix-store -qd system-1139-link system-1140-link)
```

## 迁移助手

* 首先列出磁盘
  * `lsblk`
  * `ls /dev/disk/by-label/`

* 格式化磁盘
    * `sudo cfdisk /dev/nvme1n1`
    * `sudo mkfs.btrfs -f /dev/nvme1n1p2 -R free-space-tree -L btrfs`

* 修改hardware-configuration.nix，将挂载目标改为新磁盘标号
  * `sudo nixos-rebuild boot`

* 挂载目标btrfs卷
  * `sudo mkdir /mnt`
  * `sudo mount -t btrfs -o defaults,ssd,nosuid,nodev,compress=zstd,noatime /dev/disk/by-label/backup /mnt/`

* 创建子卷
  * `sudo btrfs subvolume create /mnt/@nix`
  * `sudo btrfs subvolume create /mnt/@persist`
  * `sudo btrfs subvolume sync /mnt`

* 复制内容到新子卷
  * `sudo rsync -ah -A -X --info=progress2 /nix/ /mnt/@nix/`
  * `sudo rsync -ah -A -X --info=progress2 /persist/ /mnt/@persist/`

## wsl
无flake下临时更新flake
`nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update`

use windows proxy in wsl
```
export hostip=$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*')
export proxyPort=7890
export https_proxy="http://${hostip}:${proxyPort}";
export http_proxy="http://${hostip}:${proxyPort}";
export all_proxy="http://${hostip}:${proxyPort}";
```

fish
```
set -g all_proxy "http://$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*'):7890"
set -g https_proxy "http://$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*'):7890"
```