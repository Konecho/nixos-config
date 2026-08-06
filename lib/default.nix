# 自定义 lib（blueprint 约定：lib/default.nix → outputs.lib，模块内经 flake.lib 访问）。
# config.toml：用户邮箱 / 密码 / 附加组 / 包白名单（用户名由 blueprint 从目录名读取，见 user.nix）
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
