# deskmini 的 home-manager 配置（blueprint 约定：hosts/<hostname>/users/<user>/home-configuration.nix）。
# 目录名即用户名（blueprint 机制强制），代码中一律用 `config.home.username` / `config.username` 引用。
{flake, ...}: {
  imports = [
    flake.homeModules.identity
    flake.homeModules.common
    flake.homeModules.backup
    flake.homeModules.browsers
    flake.homeModules.commandline
    flake.homeModules.desktop
    flake.homeModules.games
    flake.homeModules.git
    flake.homeModules.gui
    flake.homeModules.music
    flake.homeModules.nix
    flake.homeModules.terminals
  ];
}
