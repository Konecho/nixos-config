# 自定义 lib（blueprint 约定：lib/default.nix → outputs.lib，specialArgs 为 { inputs, flake }）。
# 模块内通过 `flake.lib.<...>` 访问；config.toml 存放用户邮箱 / 密码 / 附加组 / 包白名单。
# 注意：用户名不再来自 config.toml，由 blueprint 从 hosts/<host>/users/<user>/ 目录名读取
# （NixOS 侧经 user.nix 的 `config.username`，home 侧经 `config.home.username`）。
{
  inputs,
  flake,
  ...
}: let
  toml = builtins.fromTOML (builtins.readFile ../config.toml);
in {
  inherit toml;
  email = toml.user.email;
}
