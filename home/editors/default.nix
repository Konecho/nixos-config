{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./helix.nix
    ./vscode.nix
  ];
}
