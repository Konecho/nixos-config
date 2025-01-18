{pkgs, ...}: {
  imports = [
    ./helix.nix
  ];
  programs = {
    vscode = {
      enable = true;
      # symlink to share vscode and codium settings
      # "~/.vscode/extensions" "~/.vscode-oss/extensions"
      # "~/.config/Code/User/settings.json" "~/.config/VSCodium/User/settings.json"
      package = pkgs.vscodium;
    };
  };
}
