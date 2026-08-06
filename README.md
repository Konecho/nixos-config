# NixOS

个人 NixOS 配置仓库（flake），两台机器，单用户模式，agenix 密钥加密，jj 版本控制。
目录结构遵循 [blueprint](https://github.com/numtide/blueprint)：目录/文件名 ↔ flake 输出一一映射，`flake.nix` 只做 input 声明与 nixpkgs 配置。

## 机器

| 主机 | 说明 |
|---|---|
| `wsl` | NixOS-WSL（当前） |
| `deskmini` | 物理台式机（hardware-configuration + disko） |

## blueprint 结构 ↔ flake 输出

机制与差异见 [docs/blueprint.md](docs/blueprint.md)，Nix 工作流见 [docs/nix.md](docs/nix.md)。

| 路径 | flake 输出 |
|---|---|
| `hosts/<host>/configuration.nix` | `nixosConfigurations.<host>` |
| `hosts/<host>/users/<user>/home-configuration.nix` | 该主机 home-manager 接线 + `homeConfigurations."<user>@<host>"` |
| `modules/nixos/<name>.nix` | `nixosModules.<name>` |
| `modules/home/<name>.nix` | `homeModules.<name>` |
| `lib/default.nix` | `lib` |
| `devshell.nix` / `formatter.nix` / `packages/` | `devShells.default` / `formatter`（`nix fmt`）/ `packages.*` |
| `checks/` | `checks.*` |

## 核心机制

- 单用户：`modules/nixos/user.nix` 创建用户并定义 `config.username`（blueprint 从目录名推导）；`modules/home/identity.nix` 设置 home 身份（邮箱来自 config.toml）
- config.toml：用户邮箱、密码、附加组与 unfree/insecure 白名单唯一来源
- agenix：`modules/nixos/age.nix` + `secrets/`，`*.age` 加密入库
- jj：提交历史以 jj 管理（仓库同时有 `.git` / `.jj`）

## 常用命令

```sh
just sys        # build + switch（wsl 上 home 随系统应用）
just home       # home-manager switch（仅 deskmini；wsl 已走 NixOS 模块，justfile 有守卫）
just update nixpkgs   # 更新 flake input
doas nixos switch .   # nixos-cli（nixos-rebuild 的 Rust 重写），FLAKE-REF 缺省按 $HOSTNAME
nix fmt         # alejandra 格式化
```

## 磁盘迁移

- `lsblk` / `ls /dev/disk/by-label/`
- 改 disko-config，用 disko 格式化
- 挂载目标改为新盘标号后 `doas nixos boot .`（先做，使启动配置可迁移）
- 复制内容：`doas rsync -ah -A -X --info=progress2 /nix/ /mnt/@nix/`、`/persist/ /mnt/@persist/`

## 部署要点

- 磁盘 disko 管理（`disko-config.nix` / `disko-raid.nix`，`hosts/deskmini/` 引入）
- 当前为 WSL：`hosts/wsl/configuration.nix` 启用 nixos-wsl、vscode-server、age.nix
- pi-agent 模型默认值在 `modules/home/commandline/pi.nix`，API key 由 `secrets/pi-auth.age` 解密到 `~/.pi/agent/auth.json`
- ⚠️ 部分模块依赖注释中的 flake input（minegrub-theme / nix-cachyos-kernel / zen-browser / winapps / stylix / pokesprite 等），启用对应 input 后恢复（预存在问题，非 blueprint 迁移引入）
