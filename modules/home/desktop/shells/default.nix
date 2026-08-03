{pkgs, ...}: {
  imports = [
    # ./ambxst.nix
    # ./ashell.nix
    # 半成品：noctalia 上游已改 API（programs.noctalia.*），本模块用的 programs.noctalia-shell 未跟上，
    # 需适配上游后再启用
    # ./noctalia.nix
    # ./caelestia.nix
    # ./dank.nix
    # ./minecraft.nix
  ];
}
