# NIX_FLAGS := "--max-jobs 1 --cores 1"
# NIX_FLAGS := "--option binary-caches \"https://mirrors.ustc.edu.cn/nix-channels/store/\""

NIX_FLAGS := ""

# 系统侧构建流已切换为 nixos-cli（`nixos`，nixos-rebuild 的 Rust 重写）：
#   nixos build   = apply --no-activate --no-boot --output ./result（同 nixos-rebuild build）
#   nixos switch  = apply（构建 + 激活）
#   nixos dry-build / dry-activate = apply 加 --dry
# FLAKE-REF 缺省按 $HOSTNAME 解析 nixosConfigurations.<host>，即同 `--flake .`
# home 侧 nixos-cli 暂无子命令，仍用 home-manager

run: home

run-offline:
    # doas nixos switch . --option substitute false
    doas nixos switch . --option binary-caches ""
    # 离线部署已构建好的 toplevel（等价旧的 nix-env --set + switch-to-configuration 两步）：
    #   doas nixos switch --store-path /nix/store/xxxx
    # 说明：--store-path 跳过求值与构建直接激活；PATH 须为合法 NixOS system closure
    #   （含 nixos-version 与 bin/switch-to-configuration，可在 CI/远程构建机产出后拷贝）；
    #   与 FLAKE-REF / --vm / --image 互斥，--output / --upgrade-all / --use-nom 被忽略

build-no-proxy:
    all_proxy= http_proxy= https_proxy= nixos build . {{ NIX_FLAGS }}

git-fix:
    doas git config --global --add safe.directory "$PWD"

update *input:
    nix flake update {{ input }}

build-home:
    home-manager build --flake . {{ NIX_FLAGS }}|& nom
    nvd diff $NIX_USER_PROFILE_DIR/profile result

home:
    home-manager switch --flake . -b backup {{ NIX_FLAGS }}

sys: build-sys git-fix switch-sys

build-sys:
    nixos build . {{ NIX_FLAGS }}|& nom
    nvd diff /run/current-system result

switch-sys:
    doas nixos switch . {{ NIX_FLAGS }}

dry-sys:
    nixos dry-build . {{ NIX_FLAGS }}

clean:
    yazi /nix/var/nix/profiles
    nix store gc

diff left *right:
    ls -l /nix/var/nix/profiles/system
    cd /nix/var/nix/profiles && nix-diff $(nix-store -qd {{ left }} {{ right }})

wsl-hostip:
    cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*'

# 无flake下临时更新flake
enable-flake:
    nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update {{ NIX_FLAGS }}

# fish shell git proxy
# set -gx HTTPS_PROXY http://192.168.2.158:7890

# doas just xxx
acitvate-proxy-on-daemon proxy:
    #!/bin/sh
    mkdir -p /run/systemd/system/nix-daemon.service.d/
    cat <<EOF >/run/systemd/system/nix-daemon.service.d/override.conf
    [Service]
    Environment="https_proxy={{proxy}}"
    EOF
    systemctl daemon-reload
    systemctl restart nix-daemon

deacitvate-proxy-on-daemon:
    #!/bin/sh
    rm /run/systemd/system/nix-daemon.service.d/override.conf
    systemctl daemon-reload
    systemctl restart nix-daemon

find-top-len:
    fd -e nix -x wc -l | sort -rn | head -n 10
