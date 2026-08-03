{inputs, ...}: {
  imports = [
    inputs.dank.homeModules.dank-material-shell
    # inputs.dank.homeModules.niri
  ];
  programs.dank-material-shell = {
    enable = true;
    # niri.enableKeybinds = true;
    # 空格：启动器；V：剪贴板；M：进程；逗号：设置；Alt+L：锁屏
    # enableSystemd = true;
    # niri.enableSpawn = true;
  };
}
