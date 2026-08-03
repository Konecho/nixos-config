# NixOS

个人 NixOS 配置仓库（flake），覆盖两台机器，单用户管理模式，密钥用 agenix 加密，版本控制使用 jj（基于 git）。

## 机器

| 主机 | 说明 |
|---|---|
| `wsl` | NixOS-WSL（当前），`hosts/wsl/` 下有 `system.nix` / `home.nix` |
| `deskmini` | 物理台式机，`hosts/deskmini/hardware-configuration.nix` |

## 核心机制

- **单用户 mono**：`modules/mono.nix` 强制单用户（用户名 `mei`、home `/home`、附加组），`config.toml` 集中存放用户信息与 unfree/insecure 包白名单；`alias.nix` 把 `user.*` 映射到 `users.users.<name>.*`
- **自动扫描**：`lib.nix` 的 `scanPath` 自动导入 `home/` 与 `system/` 下的 `.nix`（去掉 `default.nix`），新增文件即生效
- **agenix 密钥**：`system/age.nix` + `secrets/secrets.nix`（SSH 公钥注册表 + 按密文路径/属主声明），`*.age` 加密文件入库，解密到指定路径
- **jj 版本控制**：仓库同时有 `.git` / `.jj`，提交历史以 jj 管理

## 目录结构

| 目录 | 作用 |
|---|---|
| `home/` | home-manager 模块：common、nix、git、gui、commandline（fish/helix/nushell/starship/yazi/pi/scripts…）、terminals、browsers、desktop、games 等 |
| `system/` | 系统模块：core、nix、lix、age（agenix）、boot、network、services、backup、tmpfs-as-root、vm 等 |
| `hosts/` | 各主机个性化配置与硬件配置，通过 `imports` 复用一部分主电脑配置 |
| `modules/` | 共享模块：mono 单用户（`mono.nix`）、alias 映射、keybinds |
| `secrets/` | agenix：`secrets.nix` + `*.age` 加密密文 |
| `packages/` | 自定义包 |
| `data/` | 非 Nix 配置文件 |

## 常用命令

```sh
just sys        # build + switch（系统）
just home       # home-manager switch
just update nixpkgs   # 更新某个 flake input
doas nixos-rebuild switch --flake .#wsl
```

## 磁盘迁移

- 格式化磁盘
  - `lsblk`
  - `ls /dev/disk/by-label/`
  - 修改 disko-config，使用 disko 格式化磁盘
- 将挂载目标改为新磁盘标号
  - `sudo nixos-rebuild boot`
  - 这一步需要先做，使得生成的启动配置能移动到新磁盘
- 复制内容到新子卷
  - `sudo rsync -ah -A -X --info=progress2 /nix/ /mnt/@nix/`
  - `sudo rsync -ah -A -X --info=progress2 /persist/ /mnt/@persist/`

## 部署要点

- 磁盘用 disko 管理（`disko-config.nix` / `disko-raid.nix`），迁移流程见上方"磁盘迁移"
- 当前机器为 WSL，`hosts/wsl/system.nix` 启用 nixos-wsl、vscode-server、age.nix
- pi-agent 的模型默认值在 `home/commandline/pi.nix`，API key 由 `secrets/pi-auth.age` 解密到 `~/.pi/agent/auth.json`
