{config, ...}: {
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
    libvirtd = {
      enable = true;
      # enableKVM = true;
      qemu.swtpm.enable = true;
    };
    # tpm.enable = true;
  };
  programs.virt-manager.enable = true;
  # sudo virsh net-autostart default
  users.users.${config.username}.extraGroups = ["libvirt" "kvm" "vboxusers" "docker"];
  users.groups = builtins.listToAttrs (map (n: {
      name = n;
      value = {members = [config.username];};
    })
    ["libvirt" "kvm" "vboxusers" "docker"]);
}
