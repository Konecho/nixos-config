{
  pkgs,
  rootPath,
  lib,
  ...
}: let
  # get file url & hash
  file = rootPath + /data/wallpapers.md;
  linesOf = file: (lib.strings.splitString "\n" (builtins.readFile file));
  nonBlankLines = lib.filter (line: line != "" && lib.strings.hasPrefix "![" line) (linesOf file);
  line = builtins.head (lib.lists.reverseList nonBlankLines);

  nline = lib.strings.removePrefix "![" (lib.strings.removeSuffix ")" line);
  infos = lib.strings.splitString "](" nline;
  url = builtins.elemAt infos 1;
  sha256 = builtins.elemAt infos 0;
  #
  isPixiv = url: (builtins.substring 0 20 url) == "https://i.pximg.net/";
  fetchPixiv = attrs:
    pkgs.fetchurl (
      attrs // {netrcPhase = ''curlOpts="$curlOpts --referer "https://www.pixiv.net/""'';}
    );
  fetchImage = {url, ...} @ attrs: (
    if (isPixiv url)
    then (fetchPixiv attrs)
    else (pkgs.fetchurl attrs)
  );
  # image = fetchImage {
  #   url = "";
  #   sha256 = "sha256-Pj2GPfHCzPzqXYPJE/jbkLbI3PRSPyfWMxANDDNe+eI=";
  # };
  image = fetchImage {
    inherit url sha256;
  };
  theme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  wallpaper = pkgs.runCommand "image.png" {} ''
    ${pkgs.lutgen}/bin/lutgen apply -p catppuccin-mocha ${image} -o $out
  '';
in {
  stylix = {
    base16Scheme = theme;
    image = wallpaper;
    # polarity = "light"; # “either”, “light”, “dark”
  };
}
