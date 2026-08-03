# 默认 formatter（blueprint 约定：根级 formatter.nix → formatter.<system>）
# `nix fmt` 用 alejandra 格式化全部 nix 文件。
#
# 注意：Lix 的 `nix fmt` 不会把文件列表传给 formatter（实测 ARGS(0)），
# 所以和 blueprint 一样，无参数时用 git ls-files 自行遍历整个项目。
{pkgs, ...}:
pkgs.writeShellApplication {
  name = "format";

  runtimeInputs = [
    pkgs.alejandra
    pkgs.git
  ];

  text = ''
    set -euo pipefail

    # 无参数时默认格式化整个项目（git 跟踪的 .nix 文件，尊重 .gitignore）
    if [[ $# = 0 ]]; then
      prj_root=$(git rev-parse --show-toplevel 2>/dev/null || echo .)
      set -- "$prj_root"
    fi

    # 用 git 遍历：alejandra 不递归目录，且 git ls-files 能排除 .direnv/result 等
    # （GNU grep 用 -z/--null-data；--null 是 BSD 写法，nixpkgs 下无效）
    git ls-files -z "$@" | grep -z '\.nix$' | xargs --null --no-run-if-empty alejandra
  '';
}
