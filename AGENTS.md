# AGENTS.md

NixOS 配置仓库（flake）开发指南。

## 项目概览

- 单用户（mono）模式：用户名 `mei`，home 为 `/home`，用户信息集中在 `config.toml`（含 unfree/insecure 包白名单）
- 管理两台机器：`wsl`（NixOS-WSL，当前）、`deskmini`（物理机，`hosts/deskmini/`）
- `lib.nix` 的 `scanPath` 自动导入 `home/`、`system/` 下所有 `.nix`（`default.nix` 除外），新增文件即生效，无需手动注册
- 密钥用 agenix：`secrets/secrets.nix` 注册 SSH 公钥、解密路径与属主，`*.age` 加密文件入库
- 版本控制用 jj（仓库同时有 `.git` / `.jj`），提交请用 `jj`

## 常用命令

```sh
just sys                      # nixos-rebuild build + switch
just home                     # home-manager switch
just update <input>           # nix flake update <input>
doas nixos-rebuild switch --flake .#wsl
```

## 约定与注意事项

1. 改动后先 `nixos-rebuild build --flake .#<host>` 验证，再让用户执行 switch
2. 涉及密钥：改 `secrets/secrets.nix` 后用 `agenix -e secrets/<name>.age` 重新加密；明文不得写入 nix 文件或提交
3. `home/commandline/pi.nix`：pi-agent 配置。内置 provider（如 deepseek）**不要**在 models.json 里声明 `models`——同 id 会整体覆盖 catalog 条目，导致 `reasoning`/`thinkingLevelMap` 丢失、无法切换 thinking；只保留 provider 层 `baseUrl`/`api`，改单字段用 `modelOverrides`
4. `config.toml` 是用户信息的唯一来源（用户名、邮箱、组、密码哈希），改用户相关配置改这里
5. home-manager 生成的运行时配置（如 pi 的 `settings.json`/`models.json`）是 store symlink，程序运行时写不进去（pi 会静默吞掉写入错误），属预期行为，不要"修复"
6. 不需要在 `flake.nix` 里逐个注册模块：`scanPath` 已覆盖 `home/`、`system/`；主机模块在 `hosts/` 下按需 import

## 参考

- `README.md`：项目概况、目录结构、磁盘迁移步骤
- `lib.nix`：mkPkgs / mkSys / mkUsr / scanPath 核心逻辑
- `modules/mono.nix`、`modules/mono.hm.nix`：单用户模块
- `system/age.nix` + `secrets/`：agenix 密钥管理
