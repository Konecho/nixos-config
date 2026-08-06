# 单用户定义：
# - 用户名由 blueprint 目录名接线推导并暴露为 config.username（唯一定义点）
# - 邮箱/密码/附加组来自 config.toml
# - 仅用于配置了 home-manager 用户的主机（hosts/<host>/users/ 存在）
{
  lib,
  config,
  flake,
  ...
}: let
  user = flake.lib.toml.user;
  # 由 blueprint 目录名接线
  homeUsers = builtins.attrNames config.home-manager.users;
in {
  options.username = lib.mkOption {
    type = lib.types.str;
    description = "单用户模式的用户名，由 blueprint 从 hosts/<host>/users/ 目录名推导";
  };

  config = {
    username = builtins.head homeUsers;
    # home-manager 不自动建用户，由本模块创建
    home-manager.backupFileExtension = "bak";

    users.users.${config.username} = {
      isNormalUser = true;
      createHome = true;
      # home 目录唯一定义点（其余经 config.home.homeDirectory / $HOME 引用）
      home = "/home";
      hashedPassword = user.password;
      extraGroups = user.groups;
    };

    users.mutableUsers = false;
    users.extraUsers.root.initialHashedPassword = "!";

    nix.settings.trusted-users = [config.username];
  };
}
