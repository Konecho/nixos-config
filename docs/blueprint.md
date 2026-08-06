# blueprint 与普通 flake 的区别

[blueprint](https://github.com/numtide/blueprint)：flake 框架，以目录结构定义 flake 输出，取代手工注册。本项目以 flake input 引入，目录/文件名 ↔ flake 输出一一映射，新增文件即生效。

## 普通 flake

每个主机、用户、模块、包在 `flake.nix` 的 outputs 手工接线：

```nix
outputs = { self, nixpkgs, home-manager, ... }: {
  nixosConfigurations.host1 = nixpkgs.lib.nixosSystem {
    modules = [ ./hosts/host1/configuration.nix ];
    specialArgs = { ... };
  };
  homeConfigurations."user@host1" = home-manager.lib.homeManagerConfiguration { ... };
  nixosModules.foo = import ./modules/foo.nix;
  packages.default = ...;
};
```

缺点：增删主机/用户/模块需改 flake.nix；主机与 home 接线（specialArgs、pkgs 一致性、home-manager NixOS 模块）易错；输出名/路径/import 顺序人工维护。

## blueprint

```nix
# flake.nix 的 outputs 一行
outputs = inputs: inputs.blueprint { inherit inputs; };
```

自动扫描 `hosts/`、`modules/`、`lib/`、`packages/`、`checks/` 生成全部输出，并：

- 自动接线 home-manager：`hosts/<host>/users/<user>/home-configuration.nix` 同时接入该主机 home-manager NixOS 模块（`home-manager.users.<user>`）与独立 `homeConfigurations."<user>@<host>"`
- 统一注入 specialArgs：`{ inputs, flake, hostName }`
- `flake.nix` 的 `nixpkgs.config` / `nixpkgs.overlays` 应用到所有主机与 home 配置

## 目录结构 ↔ flake 输出

| 目录/文件 | flake 输出 |
|---|---|
| `hosts/<host>/configuration.nix` | `nixosConfigurations.<host>` |
| `hosts/<host>/users/<user>/home-configuration.nix` | 该主机 home-manager 模块接线 + `homeConfigurations."<user>@<host>"` |
| `modules/nixos/*.nix` | `nixosModules.*`（`flake.modules.nixos.<name>` 导入） |
| `modules/home/*.nix` | `homeModules.*`（`flake.homeModules.<name>` 导入） |
| `lib/default.nix` | `lib`（`flake.lib.*` 访问） |
| `packages/*` | `packages.<system>.*` |
| `checks/*` | `checks.<system>.*`（另自动生成 hosts/packages/devshells） |
| `devshell.nix` | `devShells.<system>.default` |
| `formatter.nix` | `formatter.<system>`（`nix fmt`） |

## 差异要点

1. 主机须自设 `nixpkgs.hostPlatform` 与 `networking.hostName`（blueprint 不设）
2. 用户不自动创建：blueprint 只接线 home-manager，创建由 `modules/nixos/user.nix` 负责
3. specialArgs 仅 `{ inputs, flake }`（另有 hostName）：无 rootPath，引用仓库内文件用相对路径（如 `modules/nixos/age.nix` 中 `../../secrets/...`）
4. homeConfigurations 位于 `legacyPackages.<system>.homeConfigurations`（顶层无；`.#homeConfigurations` 可通是 nix3 自动前缀）
5. home-manager NixOS 模块由 blueprint 自动接（`mkHomeUsersModule`）：`useGlobalPkgs` / `useUserPackages` 默认开启 → home 包经 `users.users.<name>.packages` 进 `/etc/profiles/per-user/<user>`，随系统 switch 更新，无需 home-manager CLI（wsl 的 ~/.nix-profile 处理见 `hosts/wsl/configuration.nix` 的 `homeUserProfile`）
6. 新文件需先 `git add` 才会被 flake eval 发现

## 单用户接线

- `modules/nixos/user.nix`：读 `config.home-manager.users` 推导 `config.username`，创建用户（密码/附加组来自 `config.toml`），设 `home-manager.backupFileExtension`、`trusted-users`
- `modules/home/identity.nix`：home 身份（git/jj，用户名取 `config.home.username`、邮箱来自 `flake.lib.toml`）
- 前提：仅用于配置了 home-manager 用户的主机（`hosts/<host>/users/` 存在）
