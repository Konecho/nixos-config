{
  inputs,
  pkgs,
  lib,
  config,
  flake,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    flake.modules.nixos.user
    flake.modules.nixos.core
    flake.modules.nixos.nix
    flake.modules.nixos.age
    flake.modules.nixos.lix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "wsl";

  # home 随系统 switch 应用；~/.nix-profile 指向模块 profile 并清理遗留 CLI profile
  system.activationScripts.homeUserProfile = lib.stringAfter ["users"] ''
    ln -sfn /etc/profiles/per-user/${config.username} ${config.users.users.${config.username}.home}/.nix-profile
    rm -f ${config.users.users.${config.username}.home}/.local/state/nix/profiles/profile
  '';
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
    defaultUser = config.username;
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
  # 创建 plugdev 组并把用户加入
  users.groups.plugdev.members = [config.username];
  users.users.${config.username}.extraGroups = ["plugdev"];
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  programs.nix-ld = {
    enable = true;
  };
  # services.vscode-server = {
  #   enable = true;
  #   enableFHS = true;
  # };
  services.openssh.enable = true;
}
