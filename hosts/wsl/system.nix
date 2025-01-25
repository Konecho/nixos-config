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
      /system/misc.nix
      /system/nix.nix
      /system/age
    ]);
  # services.xserver.enable=true;
  hardware.graphics.enable = true;
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
      autoAttach = [
        "1-10"
        "2-2"
        "2-1"
        "1-4"
      ];
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
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666"
    ATTRS{product}=="*CMSIS-DAP*", MODE="660", GROUP="plugdev", TAG+="uaccess"
    KERNEL=="ttyS*",MODE="0666"
    KERNEL=="ttyUSB*",MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    wsl-open
    # obsidian

    nixgl.nixGLIntel
    # glxinfo

    wget # for nix-ld code-server
  ];

  nix.gc.automatic = true;
  nix.gc.dates = "12:30";
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };
  services.vscode-server.enable = true;
  fonts.fontconfig.enable = true;
  qt.enable = true;
  qt.platformTheme = "lxqt";
  qt.style = "adwaita";
}
