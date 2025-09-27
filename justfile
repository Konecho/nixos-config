# NIX_FLAGS := "--max-jobs 1 --cores 1"
# NIX_FLAGS := "--option binary-caches \"https://mirrors.ustc.edu.cn/nix-channels/store/\""
NIX_FLAGS := ""

run: home
run-offline: # git-fix
    # doas nixos-rebuild switch --flake . --option substitute false
    doas nixos-rebuild switch --flake . --option binary-caches ""
build-no-proxy:
    all_proxy= http_proxy= https_proxy= nixos-rebuild build
    # doas nix-env -p /nix/var/nix/profiles/system --set /nix/store/xxxx
    # doas xxxxxx/bin/switch-to-configuration switch
git-fix:
    doas git config --global --add safe.directory "$PWD"
update *input:
    if [ -z {{input}} ];then nix flake update;else nix flake update {{input}};fi
build-home:
    home-manager build --flake . {{NIX_FLAGS}}|& nom
    nvd diff $NIX_USER_PROFILE_DIR/profile result
home:
    home-manager switch --flake . -b backup {{NIX_FLAGS}}
sys:build-sys git-fix switch-sys
build-sys:
    nixos-rebuild build --flake . {{NIX_FLAGS}}|& nom
    nvd diff /run/current-system result
switch-sys: # git-fix
    doas nixos-rebuild switch --flake . {{NIX_FLAGS}}
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
    nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update {{NIX_FLAGS}}
# fish shell git proxy
# set -gx HTTPS_PROXY http://192.168.2.158:7890
# doas just xxx
acitvate-proxy-on-daemon:
    #!/bin/sh
    mkdir -p /run/systemd/system/nix-daemon.service.d/
    cat <<EOF >/run/systemd/system/nix-daemon.service.d/override.conf
    [Service]
    Environment="https_proxy=http://192.168.2.158:7890"
    EOF
    systemctl daemon-reload
    systemctl restart nix-daemon
deacitvate-proxy-on-daemon:
    #!/bin/sh
    rm /run/systemd/system/nix-daemon.service.d/override.conf
    systemctl daemon-reload
    systemctl restart nix-daemon
    
