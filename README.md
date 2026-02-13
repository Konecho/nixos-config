# NixOS

## 目录结构

- `home`,`system`去掉`default.nix`
- `hosts`: 不同主机的个性化配置，通过`imports`copy一部分主电脑配置
- `data`: 非nix配置文件
- `mono.nix`: 强制单用户

## 磁盘迁移

- 格式化磁盘
  - `lsblk`
  - `ls /dev/disk/by-label/`
  - 修改disko-config，使用disko格式化磁盘

- 将挂载目标改为新磁盘标号
  - `sudo nixos-rebuild boot`
  - 这一步需要先做，使得生成的启动配置能移动到新磁盘

- 复制内容到新子卷
  - `sudo rsync -ah -A -X --info=progress2 /nix/ /mnt/@nix/`
  - `sudo rsync -ah -A -X --info=progress2 /persist/ /mnt/@persist/`