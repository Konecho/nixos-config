# AGENTS.md

NixOS 配置仓库（flake）开发指南。

## 项目概览

- 单用户模式：用户名由 blueprint 从 `hosts/<host>/users/<user>/` 目录名读取（机制强制），代码内一律用 `config.username`（NixOS 侧） / `config.home.username`（home 侧）引用，不硬编码；home 为 `/home`，邮箱/密码/附加组与 unfree/insecure 包白名单集中在 `config.toml`
- 管理两台机器：`wsl`（NixOS-WSL，当前）、`deskmini`（物理机，`hosts/deskmini/`）
- 目录结构**完全遵循 [blueprint](https://github.com/numtide/blueprint)**（作为 flake input 引入）：目录/文件名 ↔ flake 输出一一映射，新增文件即生效，无需在 flake.nix 注册
- 密钥用 agenix：`secrets/secrets.nix` 注册 SSH 公钥、解密路径与属主，`*.age` 加密文件入库
- 版本控制用 jj（仓库同时有 `.git` / `.jj`），提交请用 `jj`

## 常用命令

```sh
just sys                      # nixos-rebuild build + switch（wsl 上 home 配置随系统一起应用）
just home                     # home-manager switch（仅 deskmini 用；wsl 已走 NixOS 模块，justfile 里有主机守卫）
just update <input>           # nix flake update <input>
doas nixos-rebuild switch --flake .#wsl
nix build .#checks.x86_64-linux.yazi   # 只跑 yazi 配置 check（改 yazi.nix 后必跑，秒级）
nix flake check                        # 全部 checks（含主机 closure，较重）
nix fmt                       # alejandra 格式化
```

## blueprint 结构要点

- `hosts/<host>/configuration.nix` → `nixosConfigurations.<host>`；必须自设 `nixpkgs.hostPlatform` 与 `networking.hostName`（blueprint 不自动设）
- `hosts/<host>/users/<user>/home-configuration.nix` → 自动接线该主机 home-manager + `homeConfigurations."<user>@<host>"`；**用户本身不会被自动创建**，由 `modules/nixos/user.nix` 创建
- `modules/nixos/*.nix`、`modules/home/*.nix` → `nixosModules.*`、`homeModules.*`，主机/用户文件用 `flake.modules.nixos.<name>` / `flake.homeModules.<name>` 导入
- `lib/default.nix` → `lib` 输出，模块内经 `flake.lib.*` 访问（`flake.lib.toml` / `flake.lib.username`）
- specialArgs 只有 `{ inputs, flake }`：**没有 rootPath**，需要引用仓库内文件用相对路径（如 `modules/nixos/age.nix` 里 `../../secrets/...`）
- `devshell.nix` / `formatter.nix` / `packages/` / `checks/` 按 blueprint 约定生效
- `flake.nix` 的 `nixpkgs.config` / `nixpkgs.overlays` 会应用到所有主机与 home 配置（unfree/insecure 白名单、mypkgs、mcp-nixos overlay）

## 约定与注意事项

1. 改动后先 `nixos-rebuild build --flake .#<host>` 验证，再让用户执行 switch
2. `nix fmt` 用 alejandra（根级 `formatter.nix`）：Lix 不传文件参数，formatter 内部用 `git ls-files` 自行发现文件，**新文件需先 `git add -A` 才会被格式化**（与 flake eval 同理）
3. 涉及密钥：改 `secrets/secrets.nix` 后用 `agenix -e secrets/<name>.age` 重新加密；明文不得写入 nix 文件或提交
4. `modules/home/commandline/pi.nix`：pi-agent 配置。内置 provider（如 deepseek）**不要**在 models.json 里声明 `models`——同 id 会整体覆盖 catalog 条目，导致 `reasoning`/`thinkingLevelMap` 丢失、无法切换 thinking；只保留 provider 层 `baseUrl`/`api`，改单字段用 `modelOverrides`
5. `config.toml` 存放用户邮箱、密码、附加组与包白名单（不含用户名——用户名由 blueprint 从目录名读取），改用户相关配置改这里；模块里通过 `flake.lib.toml` 读取
6. home-manager 生成的运行时配置（如 pi 的 `settings.json`/`models.json`）是 store symlink，程序运行时写不进去（pi 会静默吞掉写入错误），属预期行为，不要"修复"
7. 单用户接线由 `modules/nixos/user.nix` + `modules/home/identity.nix` 承担（用户名由 blueprint 从目录名读取）
8. 部分模块依赖注释中的 flake input（nix-cachyos-kernel / minegrub-theme / winapps / stylix / niri-nix / hexecute 已启用；pokesprite / quickshell / NUR / zen-browser / noctalia 等仍注释）：deskmini 与各 home 配置当前均可评估；半成品模块（shells/noctalia、browsers 扩展、pkm-shell）注释中留有启用说明
9. `checks/yazi.nix`：校验 `modules/home/commandline/yazi.nix` 生成的 yazi 配置可被当前 yazi 版本解析（覆盖规则字段 name→url 等 26.x 变更、规则须含 url/mime 的校验），并取出配置里实际的 epub 预览命令做冒烟测试（container.xml 居首的非 OCF 标准 epub）。改 yazi.nix 后跑 `nix build .#checks.x86_64-linux.yazi`；home 配置里 `homeConfigurations` 在 blueprint 中位于 `legacyPackages.<system>.homeConfigurations`（顶层没有，nix3 的 `.#homeConfigurations` 能通是自动前缀）
10. **尽量不要新增非 nix 脚本**（bash/python 预览脚本等），优先组合现成工具：epub 预览 = `exiftool -json` 提取元信息（自带 EPUB 解析，不依赖 file(1) 的 mime 识别）→ `jq` 转 markdown → `glow` 渲染（见 commandline/yazi.nix）。**glow 管道必加 `CLICOLOR_FORCE=1` + `-s=$t`**：glow 检测到 stdout 非 TTY（被 piper 管道）时完全不渲染 markdown，`#`/`**`/`>` 会原样输出；`$t` 是 piper 注入的明暗主题（dark/light）。**CJK 折行**：glow 的 `-w` 只在空格处折行（纯中文不折），且 `>` 引用块在 CJK 下渲染错乱——所以预览里 glow 用 `-w=0`，折行交给 `piper-wrap.patch`（给 piper 的 `ui.Text.parse` 加 `:wrap(ui.Wrap.YES)`，yazi 侧折行 CJK 安全、自适应面板宽度）；markdown 里不要用 `>` 引用块

## 参考

- `README.md`：项目概况、blueprint 结构表、磁盘迁移步骤
- `lib/default.nix`：config.toml 读取（`toml` / `email`）；`modules/nixos/user.nix` 定义 `config.username`（推导自目录名）
- `modules/nixos/user.nix` + `modules/home/identity.nix`：单用户接线
- `modules/`：本地模块集合；`modules/home/`、`modules/nixos/` 由 blueprint 自动暴露为 homeModules/nixosModules
- `modules/nixos/age.nix` + `secrets/`：agenix 密钥管理

## MCP 使用流程（nixos server）

遇到任何 nix 相关问题（包、NixOS/home-manager/darwin 选项、flake input、版本、缓存、/nix/store）**一律先走 MCP**，不要手动 curl search.nixos.org（需要 auth，且 MCP 更快更全）。

配置：`modules/home/commandline/pi.nix` 注册 mcp-nixos（`~/.pi/agent/mcp.json` 由 home-manager 生成，store symlink）。改配置后 `just sys`（wsl 上 home 随系统模块一起应用），然后在 pi 里 `/reload`。

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
