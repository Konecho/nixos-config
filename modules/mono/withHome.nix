# mono 的 NixOS↔home-manager 集成模块。
#
# 与 nixosModules.mono 一起使用（或单独使用）：
#   - 直接导入 home-manager 的 NixOS 模块（无需用户另行接线）
#   - 强制提供 `user-hm.*` → `home-manager.users.<username>.*` 别名
#   - 把 `mono.homeModules` 接线到 `home-manager.users.<username>.imports`
{home-manager, ...}: {
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.mono;
in {
  options.mono.homeModules = mkOption {
    type = types.listOf types.unspecified;
    default = [];
    description = "home-manager modules wired into home-manager.users.<mono.username>.";
  };

  imports = [
    home-manager.nixosModules.home-manager
    (lib.modules.mkAliasOptionModule ["user-hm"] ["home-manager" "users" cfg.username])
  ];

  config = {
    home-manager.users.${cfg.username}.imports = cfg.homeModules;
  };
}
