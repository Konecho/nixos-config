# 默认 formatter（blueprint 约定：根级 formatter.nix → formatter.<system>）
# Lix 的 `nix fmt` 不传文件列表（实测 ARGS(0)），无参数时用 git ls-files 自行遍历
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

    # alejandra 不递归目录，git ls-files 排除 .direnv/result 等（GNU grep 用 -z）
    git ls-files -z "$@" | grep -z '\.nix$' | xargs --null --no-run-if-empty alejandra
  '';
}
