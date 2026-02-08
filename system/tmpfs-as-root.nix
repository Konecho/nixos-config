{
  inputs,
  config,
  ...
}: let
  username = config.mono.username;
in {
  imports = [
    inputs.preservation.nixosModules.preservation
  ];

  fileSystems = {
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

  # This module cannot be used with scripted initrd.
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        "/etc/ly/save.ini"
      ];
      directories = [
        {
          directory = config.user.home;
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

  # ref: https://github.com/nix-community/preservation/blob/main/docs/src/examples.md
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
