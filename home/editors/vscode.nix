{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./helix.nix
  ];
  programs.vscode = {
    enable = true;
    # symlink to share vscode and codium settings
    # "~/.vscode/extensions" "~/.vscode-oss/extensions"
    # "~/.config/Code/User/settings.json" "~/.config/VSCodium/User/settings.json"
    package = pkgs.vscodium;
    # profiles.default = {
    #   userSettings = lib.mkForce {};
    #   extensions = with pkgs.vscode-extensions; [
    #     ms-ceintl.vscode-language-pack-zh-hans
    #     leodevbro.blockman
    #     bbenoist.Nix
    #     jnoortheen.nix-ide
    #     mhutchie.git-graph
    #     naumovs.color-highlight
    #     scalameta.metals
    #     tamasfe.even-better-toml
    #     yzhang.markdown-all-in-one
    #     usernamehw.errorlens
    #     ms-python.python
    #     rust-lang.rust-analyzer
    #     kokakiwi.vscode-just
    #     marimo-team.vscode-marimo
    #     Leathong.openscad-language-support
    #     mkhl.direnv
    #     scala-lang.scala
    #     ms-python.black-formatter
    #   ];
    # };
  };
}
