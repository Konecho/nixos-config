# 单用户 home 身份：
# - 用户名由 home-manager 自动设置（NixOS 接线时来自 users.users.<user>，standalone 时来自
#   blueprint 的目录名默认值），代码中用 `config.home.username` 引用，不硬编码。
# - 邮箱来自 config.toml（经 flake.lib.email）。
# 每个主机的 home-configuration.nix 都应导入本模块。
{
  config,
  flake,
  ...
}: {
  home.homeDirectory = "/home";

  programs.git.settings.user = {
    name = config.home.username;
    email = flake.lib.email;
  };
  programs.jujutsu.settings.user = {
    name = config.home.username;
    email = flake.lib.email;
  };
}
