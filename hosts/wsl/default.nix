{
  config,
  inputs,
  pkgs,
  system,
  username,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
  ];
  # services.xserver.enable=true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [mesa.drivers];
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
    usbip = {
      enable = true;
      autoAttach = [];
    };
    # useWindowsDriver = true;
  };
  networking.proxy.default = "http://192.168.80.1:7890";

  environment.systemPackages = with pkgs; [
    wsl-open
    obsidian

    nixgl.nixGLIntel
    glxinfo

    wget # for nix-ld code-server
  ];

  programs.nix-ld.enable = true;
  services.vscode-server.enable = true;
}
