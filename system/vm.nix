{pkgs, ...}: {
  # boot.binfmt.emulatedSystems = ["aarch64-linux"];
  virtualisation = {
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
  };
}
