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

  # home-manager 模块模式（blueprint 自动接线，useUserPackages=true）：home 包由 NixOS 经
  # users.users.<name>.packages 装进 /etc/profiles/per-user/<user>，switch 时随系统一起更新，
  # 不再依赖 home-manager CLI。
  # 遗留状态清理（standalone CLI 时代）：~/.nix-profile 曾指向
  # ~/.local/state/nix/profiles/profile（含 home-manager-path 单元素），模块激活脚本的
  # installPackages 会 nixProfileRemove home-manager-path 把它清空，导致 PATH 里的
  # $HOME/.nix-profile/bin 失效（找不到 starship 等命令）。这里每次 switch 强制：
  #   1) ~/.nix-profile → 模块 profile（nixProfileRemove 对无 manifest 的 NixOS 静态
  #      profile 是空操作，不会触发 set -eu 失败）
  #   2) 删除遗留的 CLI profile 链接，防止任何残留引用
  system.activationScripts.homeUserProfile = lib.stringAfter ["users"] ''
    ln -sfn /etc/profiles/per-user/${config.username} /home/.nix-profile
    rm -f /home/.local/state/nix/profiles/profile
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
