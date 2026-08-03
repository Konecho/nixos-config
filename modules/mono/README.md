# mono

强制单用户（single-user）的 NixOS + home-manager 模块。独立 flake，可直接添加为 input 使用。

```nix
# flake.nix inputs
mono = {
  url = "github:<owner>/mono"; # 发布后填写
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager"; # 仅使用 withHome 时需要
};
# 本地开发：url = "path:./modules/mono";
```

## 输出

| output | 模块 | 说明 |
|---|---|---|
| `nixosModules.default` / `.mono` | `nixos.nix` | NixOS 侧：单用户强制（无依赖） |
| `nixosModules.withHome` | `withHome.nix` | NixOS↔home-manager 集成（自动接入 HM + user-hm alias + 接线） |
| `homeModules.default` / `.mono` | `home.nix` | home-manager 侧：单用户 home 身份 |

## 功能

**NixOS（`nixosModules.default`）**

- 选项：`mono.enable` / `mono.username` / `mono.groupsAdd`
- `user.*` → `users.users.<username>.*` 别名
- `user.home = /home`、`createHome`、`isNormalUser`
- `users.mutableUsers = false`、root 禁用密码登录
- `nix.settings.trusted-users = [mono.username]`、`groupsAdd` 附加组

**home-manager（`homeModules.default`）**

- 选项：`mono.enable` / `mono.username` / `mono.email`
- 固定 `home.homeDirectory = /home`、`home.username`
- git / jujutsu 身份 = 用户名 + 邮箱

**NixOS↔home-manager 集成（`nixosModules.withHome`）**

- 自动导入 home-manager 的 NixOS 模块
- 强制提供 `user-hm.*` → `home-manager.users.<username>.*` 别名
- 选项 `mono.homeModules`：自动接线到 `home-manager.users.<username>.imports`

## 使用

### 1. NixOS（必须，无依赖）

```nix
{
  modules = [
    inputs.mono.nixosModules.default
    {
      mono.username = "alice";
      # user.* 别名：等价于 users.users.alice.*
      user = {
        hashedPassword = "$6$…"; # mkpasswd -m sha-512
        extraGroups = ["wheel"];
      };
    }
  ];
}
```

### 2. NixOS + home-manager 集成（推荐，自动接线）

```nix
{
  imports = [
    inputs.mono.nixosModules.default
    inputs.mono.nixosModules.withHome
  ];
  mono.username = "alice";
  # 自动进入 home-manager.users.alice.imports，无需手写接线
  mono.homeModules = [
    # 你的 home 模块：home.packages、programs.* 等
  ];
  # 集成后 host 配置里可直接用 user-hm.*（= home-manager.users.alice.*）
}
```

### 3. home-manager 单独使用（不经过 NixOS，可选）

```nix
homeConfigurations.alice = home-manager.lib.homeManagerConfiguration {
  modules = [
    inputs.mono.homeModules.default
    {
      mono.username = "alice";
      mono.email = "alice@example.com";
    }
  ];
};
```

## 注意

- `imports` 内只能引用**外部模块显式设置**的选项（如 `mono.username`），不能引用带默认值定义在本模块的选项，否则模块系统无限递归。因此 `withHome` 无法自动探测 home-manager 是否存在，必须显式导入。
- 单用户模式锁定 `users.mutableUsers = false`，用户增删需改配置 rebuild，不能直接 `useradd`。
