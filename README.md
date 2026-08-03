# NixOS

个人 NixOS 配置仓库（flake），覆盖两台机器，单用户管理模式，密钥用 agenix 加密，版本控制使用 jj（基于 git）。
目录结构完全遵循 [blueprint](https://github.com/numtide/blueprint) 约定：目录/文件名 ↔ flake 输出一一映射，`flake.nix` 只做 input 声明与 nixpkgs 配置。

## 机器

| 主机 | 说明 |
|---|---|
| `wsl` | NixOS-WSL（当前），`hosts/wsl/configuration.nix` + `hosts/wsl/users/<user>/home-configuration.nix`（目录名即用户名，blueprint 机制） |
| `deskmini` | 物理台式机，`hosts/deskmini/configuration.nix`（含 hardware-configuration 与 disko）+ `hosts/deskmini/users/<user>/home-configuration.nix` |

## blueprint 结构 ↔ flake 输出

| 路径 | flake 输出 |
|---|---|
| `hosts/<host>/configuration.nix` | `nixosConfigurations.<host>` |
| `hosts/<host>/users/<user>/home-configuration.nix` | 自动接入该主机 home-manager + `homeConfigurations."<user>@<host>"` |
| `modules/nixos/<name>.nix` | `nixosModules.<name>`（主机经 `flake.modules.nixos.<name>` 导入） |
| `modules/home/<name>.nix` | `homeModules.<name>`（用户经 `flake.homeModules.<name>` 导入） |
| `lib/default.nix` | `lib`（模块内经 `flake.lib.<...>` 访问，如 `flake.lib.username`） |
| `devshell.nix` / `formatter.nix` / `packages/` | `devShells.default` / `formatter`（`nix fmt`，alejandra）/ `packages.*` |
| `checks/` | `checks.*`（blueprint 还会从 hosts/packages/devshells 自动生成） |

## 核心机制

- **单用户**：`modules/nixos/user.nix` 创建用户（home 目录 / 密码 / 附加组）并定义 `config.username`（由 blueprint 从目录名推导），`modules/home/identity.nix` 设置 home 身份（git/jj，用户名取 `config.home.username`、邮箱来自 config.toml）
- **config.toml**：用户邮箱、密码、附加组与 unfree/insecure 包白名单的唯一来源，`flake.nix` 用它配置 nixpkgs；用户名不在此配置
- **agenix 密钥**：`modules/nixos/age.nix` + `secrets/secrets.nix`（SSH 公钥注册表 + 按密文路径/属主声明），`*.age` 加密文件入库，解密到指定路径
- **jj 版本控制**：仓库同时有 `.git` / `.jj`，提交历史以 jj 管理

## 常用命令

```sh
just sys        # build + switch（系统）
just home       # home-manager switch（当前主机自动解析到 <user>@<host>）
just update nixpkgs   # 更新某个 flake input
doas nixos-rebuild switch --flake .#wsl
nix fmt         # alejandra 格式化
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

- 磁盘用 disko 管理（`disko-config.nix` / `disko-raid.nix`，由 `hosts/deskmini/` 引入），迁移流程见上方"磁盘迁移"
- 当前机器为 WSL，`hosts/wsl/configuration.nix` 启用 nixos-wsl、vscode-server、age.nix
- pi-agent 的模型默认值在 `modules/home/commandline/pi.nix`，API key 由 `secrets/pi-auth.age` 解密到 `~/.pi/agent/auth.json`
- ⚠️ 部分模块依赖注释中的 flake input（minegrub-theme / nix-cachyos-kernel / zen-browser / winapps / stylix / pokesprite 等），deskmini 与部分 home 模块当前无法评估，启用对应 input 后即可恢复（预先存在问题，非 blueprint 迁移引入）
