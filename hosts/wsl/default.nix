{
  config,
  pkgs,
  username,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = "${username}";
    # 创建软件的桌面快捷方式
    # startMenuLaunchers = true;
  };
  networking.proxy.default="http://192.168.80.1:7890";
  environment.systemPackages = with pkgs; [
    wsl-open
    nil # for nix lsp
  ];
}
