{
  pkgs,
  rootPath,
  ...
}: {
  home.packages = with pkgs; (let
    write = name: (
      writeShellScriptBin name (builtins.readFile (rootPath + "/data/${name}"))
    );
  in [
    (write "hello")
    (write "sandbar-status")
    pamixer
    (write "sandbar-bar")
    sandbar
    (write "cliphist-fzf-sixel")
    wl-clipboard
    chafa
    wezterm
    (write "river-slurp-term")
    slurp
    alacritty
    (write "catimg-pokemon")
    catimg
  ]);
  services.cliphist.enable = true;
}
