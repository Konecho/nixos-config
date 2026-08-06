# AGENTS.md

NixOS 配置仓库（flake）开发指南。分类文档见 `docs/`：

- [docs/blueprint.md](docs/blueprint.md)：blueprint 与普通 flake 区别、结构映射、接线要点
- [docs/nix.md](docs/nix.md)：Nix 工作流与 MCP 查询

## 项目概览

- 单用户：用户名由 blueprint 从 `hosts/<host>/users/<user>/` 目录名读取，代码用 `config.username`（NixOS 侧）/ `config.home.username`（home 侧），不硬编码；用户信息（邮箱/密码/附加组）与 unfree/insecure 白名单集中在 `config.toml`
- home 目录不硬编码：运行期脚本用 `$HOME`，Nix 侧用 `config.home.homeDirectory` / `config.users.users.<name>.home`（唯一定义点在 `modules/nixos/user.nix`；identity.nix 的显式同值仅 standalone 需要）
- 两台机器：`wsl`（NixOS-WSL，当前）、`deskmini`（物理机）
- 目录结构遵循 [blueprint](https://github.com/numtide/blueprint)：目录/文件名 ↔ flake 输出一一映射，新增文件即生效
- 密钥用 agenix（`secrets/`，`*.age` 加密入库）；版本控制用 jj（**提交用 `jj`，非 git**）

## 常用命令

```sh
just sys                      # 系统 build + switch（wsl 上 home 随系统应用）
just home                     # home-manager switch（仅 deskmini；wsl 已走 NixOS 模块，justfile 有守卫）
just update <input>           # nix flake update <input>
nix build .#checks.x86_64-linux.yazi   # 改 yazi.nix 后必跑
nix flake check                        # 全部 checks（较重）
nix fmt                       # alejandra 格式化
```

## 基本规则

1. 改动后先 `nixos build .` 验证，再执行 `just sys`
2. 密钥：改 `secrets/secrets.nix` 后 `agenix -e secrets/<name>.age` 重新加密；**明文不得写入 nix 文件或提交**
3. 新文件需先 `git add -A` 才会被 flake eval 和 `nix fmt` 发现
4. `modules/home/commandline/pi.nix`：内置 provider（如 deepseek）**不要**声明 `models`——同 id 整体覆盖 catalog 条目（丢失 `reasoning`/`thinkingLevelMap`，无法切换 thinking）；只保留 provider 层 `baseUrl`/`api`，改单字段用 `modelOverrides`
5. home-manager 生成的运行时配置（pi 的 `settings.json`/`models.json`）是 store symlink，程序写不进去（pi 静默吞错）——**预期行为，勿"修复"**
6. nix 问题**一律先走 MCP**（`mcp({connect:"nixos"})`），勿手动 curl search.nixos.org；模板见 docs/nix.md
7. 优先组合现成工具，少写非 nix 脚本（epub 预览 = exiftool → jq → glow；glow 必加 `CLICOLOR_FORCE=1`，详见 docs/nix.md）
8. 注释精简：只留必要极简信息（几个词或不需要），机制细节放 docs/；不用口语词（如"兜底"）
9. markdown 描述精简：语义不变前提下减少口语化与冗余噪声

## 快速 CLI 工具（系统已装，优先使用）

| 慢 | 快 | 说明 |
|---|---|---|
| grep | `rg` | 遵守 .gitignore |
| find | `fd` | 友好 |
| cat | `bat` | 高亮 + 分页 |
| sed | `sd` | 简单替换 |
| ls | `lsd` | 颜色/图标 |
| ps | `procs` | 可读进程列表 |
| du | `dust` | 磁盘占用 |
| cd | `zoxide`（`z`） | 智能跳转 |
| git diff | `delta` | 高亮 diff |
| — | `jq` | JSON 处理 |

## 参考

- `README.md`：项目概况、blueprint 结构表、磁盘迁移
- `docs/blueprint.md`：blueprint 与普通 flake 区别、结构映射、接线要点
- `docs/nix.md`：Nix 工作流、flake inputs、checks、MCP 流程
- `lib/default.nix`：config.toml 读取（`toml` / `email`）
- `modules/nixos/user.nix` + `modules/home/identity.nix`：单用户接线
- `modules/nixos/age.nix` + `secrets/`：agenix 密钥
