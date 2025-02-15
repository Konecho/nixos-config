{pkgs, ...}: let
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
  image = fetchImage {
    url = "https://i.pximg.net/img-original/img/2024/04/28/21/39/34/118242824_p0.png";
    sha256 = "sha256-0QgFLaTo6Da7HWk9sTUQGWCabgKelgA/qs40Cp8/gLw=";
  };
  theme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
  pypkgs = python-packages:
    with python-packages; [
      image-go-nord
    ];
  py = pkgs.python3.withPackages pypkgs;
  wallpaper = pkgs.runCommand "image.png" {} ''
    ${pkgs.lutgen}/bin/lutgen apply -p catppuccin-mocha ${image} -o $out
  '';
in {
  stylix = rec {
    base16Scheme = theme;
    image = wallpaper;
    # polarity = "light"; # “either”, “light”, “dark”
  };
}
