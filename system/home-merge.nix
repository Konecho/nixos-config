{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
  ];

  boot.supportedFilesystems = ["fuse"];
  programs.fuse.userAllowOther = true;

  fileSystems."/home" = let
    homeBind = "/persist/home";
    dataBind = "/persist/data";
    coldBind = "/backup/cold";
  in {
    device = "${homeBind}:${dataBind}:${coldBind}";
    fsType = "fuse.mergerfs";
    options = [
      "defaults"
      "allow_other"
      "use_ino" # 必须开启：为虚拟文件提供统一 Inode，防止 trash 工具误判为“异构文件系统”
      "category.create=epff" # 维持你的偏好：新文件优先写入 SSD1
      "minfreespace=20G"

      "cache.files=partial"
      "dropcacheonclose=true"
      "ignorepponrename=true"

      # 确保挂载顺序在物理磁盘和 tmpfiles 权限初始化之后
      "x-systemd.after=systemd-tmpfiles-setup.service"
      "x-systemd.requires=persist.mount"
      "x-systemd.requires=backup.mount"
      # "x-systemd.after=backup.mount"
    ];
    depends = ["/persist" "/backup"];
  };

  systemd.tmpfiles.rules = [
    # 1. 开放物理挂载点的“穿透”权限 (0755)
    # 消除 "os error 13 (Permission denied)"，让 trash 工具能探测到物理盘根部的回收站
    "z /backup 0755 root users -"
    "z /persist 0755 root users -"
    "z /backup/cold 0755 root users -"

    # 2. 物理层“遍地开花”：在每个物理分支根部预建回收站结构
    # 确保无论文件物理在哪块盘，MergerFS 逻辑层都能命中“同盘移动”的条件
    "d /persist/home/.Trash-1000 1700 ${config.mono.username} users -"
    "d /persist/data/.Trash-1000 1700 ${config.mono.username} users -"
    "d /backup/cold/.Trash-1000  1700 ${config.mono.username} users -"

    # 3. 逻辑层“偷梁换柱”：将用户的默认回收站路径强行链接到 MergerFS 内部
    # 彻底解决 "os error 18 (Invalid cross-device link)"
    # 即使工具尝试回退到 ~/.local，实际上也会在 /home 内部完成 rename 操作
    "L+ /home/.local/share/Trash - - - - /home/.Trash-1000"
  ];
}
