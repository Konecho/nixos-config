run:
    just -l
update *input:
    nix flake update
    if [ -z {{input}} ];then nix flake update;else nix flake lock --update-input {{input}};fi
home:
    home-manager build --flake . -b backup |& nom
    nvd diff $NIX_USER_PROFILE_DIR/profile result
    home-manager switch --flake . -b backup
sys:
    nixos-rebuild build |& nom
    nvd diff /run/current-system result
    doas nixos-rebuild switch