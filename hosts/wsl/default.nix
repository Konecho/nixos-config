{
  config,
  pkgs,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = "mei";
    # 创建软件的桌面快捷方式
    # startMenuLaunchers = true;
  };
  networking.hostName = "wsl";
  environment.systemPackages = with pkgs; [
    wsl-open
    nil # for nix lsp
  ];
}
