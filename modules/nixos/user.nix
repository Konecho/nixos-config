# 单用户定义：
# - 用户名由 blueprint 从 hosts/<host>/users/<user>/ 目录名读取，经
#   `home-manager.users.<user>` 接线进来，这里从该接线推导并暴露为 `config.username`，
#   代码中一律用 `config.username` 引用，不硬编码用户名。
# - 用户信息（邮箱 / 密码 / 附加组）来自 config.toml（经 flake.lib.toml）。
# - 前提：本模块只在配置了 home-manager 用户的主机上使用（即 hosts/<host>/users/ 存在）。
{
  lib,
  config,
  flake,
  ...
}: let
  user = flake.lib.toml.user;
  # blueprint 从 hosts/<host>/users/<user>/ 目录名接线到 home-manager.users.<user>
  homeUsers = builtins.attrNames config.home-manager.users;
in {
  options.username = lib.mkOption {
    type = lib.types.str;
    description = "单用户模式的用户名，由 blueprint 从 hosts/<host>/users/ 目录名推导";
  };

  config = {
    username = builtins.head homeUsers;
    # 用户由本模块创建（home-manager 的 NixOS 模块不做自动创建，只从 users.users.<name> 读取）
    home-manager.backupFileExtension = "bak";

    users.users.${config.username} = {
      isNormalUser = true;
      createHome = true;
      home = "/home";
      hashedPassword = user.password;
      extraGroups = user.groups;
    };

    users.mutableUsers = false;
    users.extraUsers.root.initialHashedPassword = "!";

    nix.settings.trusted-users = [config.username];
  };
}
