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
          how = "symlink";
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
  # A work round for systemd-machine-id-commit.
  # See https://github.com/NixOS/nixpkgs/issues/351151 and issues in preservation and
  # impermanence.
  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persist/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persist"
    ];
  };
}
