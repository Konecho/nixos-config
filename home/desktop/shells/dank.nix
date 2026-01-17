{inputs, ...}: {
  imports = [
    inputs.dank.homeModules.dankMaterialShell.default
    inputs.dank.homeModules.dankMaterialShell.niri
  ];
  programs.dankMaterialShell = {
    enable = true;
    niri.enableKeybinds = true;
    # 空格：启动器；V：剪贴板；M：进程；逗号：设置；Alt+L：锁屏
    # enableSystemd = true;
    niri.enableSpawn = true;
  };
}
