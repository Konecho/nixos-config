{
  inputs,
  username,
  ...
}: {
  imports = [
    # inputs.impermanence.nixosModules.impermanence
    inputs.preservation.nixosModules.preservation
  ];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=2G"
      "mode=755"
    ];
  };

  # environment.persistence."/persist" = {
  #   directories = [
  # "/home"
  # "/etc/nixos"
  # "/etc/NetworkManager/system-connections"
  # "/var/log"
  # "/var/lib"
  # ];
  # files = [
  # "/etc/machine-id"
  # "/etc/passwd"
  # "/etc/shadow"
  #   ];
  # };
  # This module cannot be used with scripted initrd.
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];
      directories = [
        {
          directory = "/home";
          user = username;
          group = "users";
          # mode = "0700";
        }
        {
          directory = "/etc/nixos";
          user = username;
          group = "users";
        }
        "/etc/NetworkManager/system-connections"
        "/var/log"
        "/var/lib"
      ];
      users.${username} = {};
    };
  };
}
