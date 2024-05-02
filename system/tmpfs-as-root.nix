{inputs, ...}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=2G" "mode=755"];
  };

  environment.persistence."/persist" = {
    directories = [
      "/home"
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      # "/etc/passwd"
      # "/etc/shadow"
    ];
  };
}
