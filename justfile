run:
    just -l
update *input:
    if [ -z {{input}} ];then nix flake update;else nix flake lock --update-input {{input}};fi
home:
    home-manager build --flake . -b backup |& nom
    nvd diff $NIX_USER_PROFILE_DIR/profile result
    home-manager switch --flake . -b backup
sys:
    nixos-rebuild build --flake . |& nom
    nvd diff /run/current-system result
    doas nixos-rebuild switch --flake .
clean:
    yazi /nix/var/nix/profiles
    nix store gc
diff left *right:
    ls -l /nix/var/nix/profiles/system
    cd /nix/var/nix/profiles && nix-diff $(nix-store -qd {{left}} {{right}})
wsl-hostip:
    cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*'
# 无flake下临时更新flake
enable-flake:
    nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update