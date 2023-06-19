{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wl-clipboard # waydroid copy&paste
  ];
  virtualisation = {
    # anbox.enable = true;
    # libvirtd.enable = true;
    virtualbox = {
      host.enable = true;
      # guest.enable = true;
    };
    docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        # setSocketVariable = true;
      };
    };
    waydroid.enable = true;
    lxd.enable = true;
  };
}
