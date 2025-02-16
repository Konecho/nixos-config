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
    url = "https://cdn.donmai.us/original/c8/8f/__sky_striker_ace_raye_and_sky_striker_ace_roze_yu_gi_oh_drawn_by_hsin__c88fc0854b81bf712988523733200729.jpg";
    sha256 = "sha256-Pj2GPfHCzPzqXYPJE/jbkLbI3PRSPyfWMxANDDNe+eI=";
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
