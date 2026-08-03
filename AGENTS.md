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
- `modules/`：本地模块集合（`modules/mono/` 独立 flake，经 `inputs.mono` 引入，可发布到 GitHub 后改 URL）；新增模块仿照 mono 结构
- `system/age.nix` + `secrets/`：agenix 密钥管理

## MCP 使用流程（nixos server）

遇到任何 nix 相关问题（包、NixOS/home-manager/darwin 选项、flake input、版本、缓存、/nix/store）**一律先走 MCP**，不要手动 curl search.nixos.org（需要 auth，且 MCP 更快更全）。

配置：`home/commandline/pi.nix` 注册 mcp-nixos（`~/.pi/agent/mcp.json` 由 home-manager 生成，store symlink）。改配置后 `just home`，然后在 pi 里 `/reload`。

两个工具：
- `nixos_nix`：统一查询，`action` ∈ search / info / stats / browse / channels / flake-inputs / cache / store，`source` ∈ nixos（默认）/ home-manager / darwin / flakes / flakehub / nixvim / wiki / nix-dev / noogle / nixhub
- `nixos_nix_versions`：NixHub 版本历史（哪个 commit 发货了某版本）

常用调用模板（直接照抄）：
```
包搜索              → nixos_nix  {"action":"search","query":"X"}                       # 默认 type=packages
包是否在频道         → nixos_nix  {"action":"info","query":"X","channel":"Y"}
NixOS 选项搜索      → nixos_nix  {"action":"search","query":"X","type":"options"}
home-manager 选项   → nixos_nix  {"action":"search","query":"X","source":"home-manager"}
选项树浏览（前缀）   → nixos_nix  {"action":"browse","query":"programs.git","source":"home-manager"}
版本历史            → nixos_nix_versions {"package":"X","version":"Y"}

⚠ action 必填，缺了会报 missing argument。
⚠ home-manager 选项源当前依赖本地 overlay（上游 #192 修复，未发 release）：
  `just update mcp-nixos` 跟随上游 main；nixpkgs 更新后可删 flake.nix 里的 input+overlay。
⚠ pi 启动时一次性加载 mcp.json：rebuild 后必须 `/reload`，再 mcp({connect:"nixos"})；
  lazy 常驻进程不会自动重启，必要时 kill 旧进程 + 删 ~/.pi/agent/mcp-cache.json。
```

## 快速 CLI 工具（系统已装，优先使用）

能用 Rust/Go 系快工具就不用手动慢命令：

| 慢 | 快 | 说明 |
|---|---|---|
| grep | `rg` | 默认遵守 .gitignore，更快 |
| find | `fd` | 更快更友好，`fd -t f -e nix pattern` 等 |
| cat 读文件 | `bat`（或 read 工具） | 语法高亮 + 分页 |
| sed | `sd` | 简单替换语法 |
| ls | `lsd` | 颜色/图标 |
| ps | `procs` | 可读进程列表 |
| du | `dust` | 交互式磁盘占用 |
| cd | `zoxide`（`z`） | 智能跳转 |
| git diff | `delta` | 高亮 diff |
| — | `jq` | JSON 处理（C，非 rust 但标配） |

用法注意：搜代码用 `rg`；找文件用 `fd`；看进程 `procs`；磁盘占用 `dust`；`lsd` 的别名 `ls` 已由 shell 配置接管时直接 `ls` 即可。
