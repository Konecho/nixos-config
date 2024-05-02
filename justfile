run:
    just -l
update:
    nix flake update
home:
    home-manager switch --flake /etc/nixos -b backup
sys:
    doas nixos-rebuild switch