{
  config,
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "${username}";
    # 创建软件的桌面快捷方式
    # startMenuLaunchers = true;
    extraBin = with pkgs; [
      {src = "${coreutils}/bin/uname";}
      {src = "${coreutils}/bin/dirname";}
      {src = "${coreutils}/bin/readlink";}
    ];
  };
  networking.proxy.default = "http://192.168.80.1:7890";

  environment.systemPackages = with pkgs; [
    wsl-open
    obsidian

    wget # for nix-ld code-server
  ];

  programs.nix-ld.enable = true;
  services.vscode-server.enable = true;
}
