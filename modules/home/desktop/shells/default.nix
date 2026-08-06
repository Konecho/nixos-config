{pkgs, ...}: {
  imports = [
    # ./ambxst.nix
    # ./ashell.nix
    # 半成品：noctalia 上游改 API（programs.noctalia.*），需适配后启用
    # ./noctalia.nix
    # ./caelestia.nix
    # ./dank.nix
    # ./minecraft.nix
  ];
}
