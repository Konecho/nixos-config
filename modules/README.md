# modules

本仓库的本地模块集合。目录组织遵循 [blueprint](https://github.com/numtide/blueprint) 约定：

- `home/`：home-manager 模块，blueprint 自动暴露为 `homeModules.<name>`，用户配置（`hosts/<host>/users/<user>/home-configuration.nix`）用 `flake.homeModules.<name>` 导入
- `nixos/`：NixOS 系统模块，暴露为 `nixosModules.<name>`，主机配置用 `flake.modules.nixos.<name>` 导入

| 目录 | 说明 |
|---|---|
| `home/` | home-manager 模块（blueprint 自动暴露） |
| `nixos/` | NixOS 系统模块（blueprint 自动暴露） |
