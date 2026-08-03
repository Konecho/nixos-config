# 默认 devshell（blueprint 约定：根级 devshell.nix → devShells.<system>.default）
{pkgs, ...}:
pkgs.mkShell {
  packages = with pkgs; [
    hello
  ];
}
