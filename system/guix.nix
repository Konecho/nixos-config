{pkgs, ...}: {
  services.guix = {
    enable = true;
    storeDir = "/gnu/store";
    stateDir = "/gnu/var";
    extraArgs = [
      "--substitute-urls=https://mirror.sjtu.edu.cn/guix/"
    ];
  };
}
