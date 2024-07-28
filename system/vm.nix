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
    };
  };
}
