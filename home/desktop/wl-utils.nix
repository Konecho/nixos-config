{
  pkgs,
  rootPath,
  ...
}: {
  home.packages = with pkgs; (let
    write = name: (
      writeShellScriptBin name (builtins.readFile (rootPath + "/data/${name}"))
    );
    writePy = name: (
      writers.writePython3Bin name {} (builtins.readFile (rootPath + "/data/${name}"))
    );
  in [
    (write "sandbar-status")
    pamixer
    (write "sandbar-bar")
    sandbar
    # (write "cliphist-fzf-sixel")
    # wl-clipboard
    # chafa
    # wezterm
    (write "river-slurp-term")
    slurp
    alacritty

    # wayland
    lswt
    wbg
  ]);
  services.cliphist.enable = true;
}
