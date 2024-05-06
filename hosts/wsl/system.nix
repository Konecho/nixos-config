{
  config,
  inputs,
  pkgs,
  system,
  username,
  rootPath,
  ...
}: {
  imports =
    [
      inputs.nixos-wsl.nixosModules.wsl
      inputs.vscode-server.nixosModules.default
    ]
    ++ (map (path: rootPath + path) [
      /system/core.nix
      /system/locale.nix
      /system/misc.nix
      /system/nix.nix
      /system/age
    ]);
  # services.xserver.enable=true;
  hardware.opengl.enable = true;
  # hardware.opengl.extraPackages = with pkgs; [mesa.drivers];
  wsl = {
    enable = true;
    defaultUser = "${username}";
    # 创建软件的桌面快捷方式
    # startMenuLaunchers = true;
    extraBin = with pkgs; [
      {src = "${coreutils}/bin/uname";}
      {src = "${coreutils}/bin/dirname";}
      {src = "${coreutils}/bin/cat";}
      {src = "${linuxPackages.usbip}/bin/usbip";}
    ];
    usbip = {
      enable = true;
      autoAttach = ["1-10" "2-2" "2-1"];
    };
    interop.register = true;
    # useWindowsDriver = true;
    # docker-desktop.enable = true;
    # wslConf.user.default = "${username}";
  };
  users.groups.plugdev.members = ["${username}"];
  # users.users."${username}".extraGroups = ["plugdev"]; # not work
  networking.proxy.default = "http://192.168.80.1:7890";
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", GROUP="plugdev", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", GROUP="plugdev", TAG+="uaccess"
    ATTRS{product}=="*CMSIS-DAP*", MODE="660", GROUP="plugdev", TAG+="uaccess"
    KERNEL=="ttyS*",MODE="0666"
    KERNEL=="ttyUSB*",MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    wsl-open
    # obsidian

    # nixgl.nixGLIntel
    # glxinfo

    wget # for nix-ld code-server
  ];

  programs.nix-ld.enable = true;
  services.vscode-server.enable = true;
}
