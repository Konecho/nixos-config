{...}: {
  imports = [
    ./boot.nix
    ./locale.nix
    ./misc.nix
    ./network.nix
    ./packages.nix
    ./tmpfs-as-root.nix
    ./tty.nix
  ];
}