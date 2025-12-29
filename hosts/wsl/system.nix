{
  config,
  inputs,
  pkgs,
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
      /system/nix.nix
      /system/age.nix
      /modules/mono.nix
    ]);
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";
  nixpkgs.overlays = [
    inputs.nixgl.overlay
  ];
  # services.xserver.enable=true;
  hardware.graphics.enable = true;
  # hardware.opengl.extraPackages = with pkgs; [mesa.drivers];
  wsl = {
    enable = true;
    defaultUser = config.mono.username;
    # 创建软件的桌面快捷方式
    # startMenuLaunchers = true;
    extraBin = with pkgs; [
      {src = "${coreutils}/bin/uname";}
      {src = "${coreutils}/bin/dirname";}
      {src = "${coreutils}/bin/readlink";}
      {src = "${coreutils}/bin/cat";}
      {src = "${coreutils}/bin/sed";}
      {src = "/run/current-system/sw/bin/sed";}
    ];
    usbip = {
      enable = true;
      autoAttach = [
      ];
    };
    interop.register = true;
    # useWindowsDriver = true;
    # docker-desktop.enable = true;
    # wslConf.user.default = "${username}";
  };
  systemd.user = {
    paths.vscode-remote-workaround = {
      wantedBy = ["default.target"];
      pathConfig.PathChanged = "%h/.vscode-server/bin";
    };
    services.vscode-remote-workaround.script = ''
      for i in ~/.vscode-server/bin/*; do
        echo "Fixing vscode-server in $i..."
        ln -sf ${pkgs.nodejs}/bin/node $i/node
      done
    '';
  };
  mono.groupsAdd = ["plugdev"];
  services.udev.extraRules = ''
  '';

  environment.systemPackages = with pkgs; [
    wsl-open
    # obsidian

    # nixgl.nixGLIntel
    # glxinfo

    wget # for nix-ld code-server

    # gnuradio
  ];

  nix.gc.automatic = true;
  nix.gc.dates = "18:00";
  programs.nix-ld = {
    enable = true;
  };
  services.vscode-server = {
    enable = true;
    # enableFHS = true;
  };
}
