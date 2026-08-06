# modules

本地模块集合，目录组织遵循 [blueprint](https://github.com/numtide/blueprint)：

| 目录 | 说明 |
|---|---|
| `home/` | home-manager 模块，blueprint 暴露为 `homeModules.<name>`，用户配置经 `flake.homeModules.<name>` 导入 |
| `nixos/` | NixOS 模块，暴露为 `nixosModules.<name>`，主机配置经 `flake.modules.nixos.<name>` 导入 |
