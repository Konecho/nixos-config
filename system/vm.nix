{
  pkgs,
  username,
  inputs,
  system,
  ...
}: {
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
  users.groups.libvirt.members = [username];
  users.groups.kvm.members = [username];
  environment.systemPackages = with inputs.winapps.packages.${system}; [winapps winapps-launcher];
}
