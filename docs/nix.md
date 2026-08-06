# Nix 工作流与查询

## 常用命令

```sh
just sys                      # 系统 build + switch（wsl 上 home 随系统应用）
just update <input>           # nix flake update <input>
nix build .#checks.x86_64-linux.yazi   # 改 yazi.nix 后必跑
nix flake check                        # 全部 checks（较重）
nix fmt                       # alejandra 格式化
```

系统侧构建用 nixos-cli（`nixos`，nixos-rebuild 的 Rust 重写）：build/switch/dry-build 为 apply 变体；FLAKE-REF 缺省按 `$HOSTNAME` 解析（同 `--flake .`）。

## 工作流

### 构建验证

改动后先 `nixos build .` 验证，再执行 `just sys`。

### nix fmt

- 根级 `formatter.nix` 用 `git ls-files` 发现 `.nix` 文件（Lix 不传文件参数）
- **新文件需先 `git add -A` 才会被格式化**

### 密钥（agenix）

- `secrets/secrets.nix` 注册 SSH 公钥、解密路径与属主；`*.age` 加密入库（`modules/nixos/age.nix` 接线）
- 改 `secrets/secrets.nix` 后 `agenix -e secrets/<name>.age` 重新加密；**明文不得写入 nix 文件或提交**

### flake inputs 状态

已启用：nixpkgs、nixos-hardware、impermanence、preservation、my-nixpkgs、nix-cachyos-kernel、nixos-cli、home-manager、disko、nixos-wsl、vscode-server、nix-index-database、mcp-nixos、agenix、nixgl、stylix、direnv-instant、blueprint、niri-nix、minegrub-theme、minecraft-plymouth-theme、minesddm、winapps、hexecute。

仍注释（半成品/未启用）：pokesprite、quickshell、NUR、zen-browser、noctalia、dank、caelestia、ambxst 等。部分模块（shells/noctalia、browsers 扩展、pkm-shell）注释中留有启用说明；当前 deskmini 与各 home 配置均可评估。

### checks

- `checks/yazi.nix`：校验 yazi 配置可被当前版本解析（规则字段 name→url 等 26.x 变更、规则须含 url/mime），并对 epub 预览命令冒烟测试（container.xml 居首的非 OCF 标准 epub）
- 改 yazi.nix 后跑 `nix build .#checks.x86_64-linux.yazi`

### 包组合约定（少写非 nix 脚本）

- epub 预览 = `exiftool -json`（自带 EPUB 解析）→ `jq` 转 markdown → `glow` 渲染（commandline/yazi.nix）
- glow 必加 `CLICOLOR_FORCE=1` + `-s=$t`：stdout 非 TTY（piper 管道）时不渲染 markdown；`$t` 为 piper 注入主题
- CJK 折行：glow 用 `-w=0`，折行交 `piper-wrap.patch`（`ui.Text.parse` 加 `:wrap(ui.Wrap.YES)`）；markdown 不用 `>` 引用块

## MCP 使用流程（nixos server）

nix 问题（包、选项、flake input、版本、缓存、/nix/store）**一律先走 MCP**，勿手动 curl search.nixos.org。

配置：`modules/home/commandline/pi.nix` 注册 mcp-nixos（`~/.pi/agent/mcp.json` 由 home-manager 生成，store symlink）。改配置后 `just sys`，然后在 pi 里 `/reload`。

工具：

- `nixos_nix`：`action` ∈ search / info / stats / browse / channels / flake-inputs / cache / store，`source` ∈ nixos（默认）/ home-manager / darwin / flakes / flakehub / nixvim / wiki / nix-dev / noogle / nixhub
- `nixos_nix_versions`：NixHub 版本历史（哪 commit 发货某版本）

模板：

```
包搜索              → nixos_nix  {"action":"search","query":"X"}                       # 默认 type=packages
包是否在频道         → nixos_nix  {"action":"info","query":"X","channel":"Y"}
NixOS 选项搜索      → nixos_nix  {"action":"search","query":"X","type":"options"}
home-manager 选项   → nixos_nix  {"action":"search","query":"X","source":"home-manager"}
选项树浏览（前缀）   → nixos_nix  {"action":"browse","query":"programs.git","source":"home-manager"}
版本历史            → nixos_nix_versions {"package":"X","version":"Y"}

⚠ action 必填。
⚠ home-manager 选项源依赖本地 overlay（上游 #192 未发 release）：`just update mcp-nixos` 跟随 main；nixpkgs 更新后可删 flake.nix 的 input+overlay。
⚠ pi 启动时一次性加载 mcp.json：rebuild 后必须 `/reload`；lazy 常驻进程不自动重启，必要时 kill + 删 ~/.pi/agent/mcp-cache.json。
```
