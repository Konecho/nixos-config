{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wl-clipboard # waydroid copy&paste
  ];

  virtualisation = {
    # anbox.enable = true;
    # libvirtd.enable = true;
    # virtualbox = {
    #   host.enable = true;
    #   # guest.enable = true;
    # };
    docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        # setSocketVariable = true;
      };
      daemon.settings = {
        "registry-mirrors" = [
          "https://docker.mirrors.ustc.edu.cn"
          "https://registry.docker-cn.com"
          "http://hub-mirror.c.163.com"
        ];
      };
    };
    # waydroid.enable = true;
    lxd.enable = true;
  };
  # https://github.com/docker/docker-install/issues/150
  # virtualisation.docker.rootless.daemon.settings = {
  #   "http-proxy" = "";
  #   "https-proxy" = "";
  # };
}
