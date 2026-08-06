{
  pkgs,
  config,
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
    # 物理挂载点 0755：trash 需探测物理盘根回收站（消除 os error 13）
    "z /backup 0755 root users -"
    "z /persist 0755 root users -"
    "z /backup/cold 0755 root users -"

    # 物理分支根预建回收站：命中同盘移动
    "d /persist/home/.Trash-1000 1700 ${config.username} users -"
    "d /persist/data/.Trash-1000 1700 ${config.username} users -"
    "d /backup/cold/.Trash-1000  1700 ${config.username} users -"

    # 默认回收站路径链到 MergerFS 内：避免 os error 18 跨设备 rename
    "L+ /home/.local/share/Trash - - - - /home/.Trash-1000"
  ];
}
