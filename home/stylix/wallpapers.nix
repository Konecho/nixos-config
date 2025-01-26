{pkgs, ...}: let
  isPixiv = url: (builtins.substring 0 20 url) == "https://i.pximg.net/";
  fetchPixiv = attrs:
    pkgs.fetchurl (
      attrs
      // {
        netrcPhase = ''
          curlOpts="$curlOpts --referer "https://www.pixiv.net/""
        '';
      }
    );
  fetchImage = {url, ...} @ attrs: (
    if (isPixiv url)
    then (fetchPixiv attrs)
    else (pkgs.fetchurl attrs)
  );
  images = {
    light = [
      (fetchImage {
        url = "https://i.pximg.net/img-original/img/2024/04/28/21/39/34/118242824_p0.png";
        sha256 = "sha256-0QgFLaTo6Da7HWk9sTUQGWCabgKelgA/qs40Cp8/gLw=";
      })
      (fetchImage {
        url = "https://pbs.twimg.com/media/GhYgRg8aQAAuh6n.jpg";
        sha256 = "sha256-iX/oUWKbkWRFWHCeJCjRj0DrxNX+toH4+QMCl4NdcKo=";
      })
      (fetchImage {
        url = "https://i.pximg.net/img-original/img/2024/05/07/23/02/42/118530334_p0.png";
        sha256 = "sha256-5E/ZbcOtB8019sGO5oA+G5fIV5N34fffkIvpmstWmnU=";
      })
      (fetchImage {
        url = "https://cdn.donmai.us/original/c8/8f/__sky_striker_ace_raye_and_sky_striker_ace_roze_yu_gi_oh_drawn_by_hsin__c88fc0854b81bf712988523733200729.jpg";
        sha256 = "sha256-Pj2GPfHCzPzqXYPJE/jbkLbI3PRSPyfWMxANDDNe+eI=";
      })
      (fetchImage {
        url = "https://cdn.donmai.us/original/dd/f7/__original_drawn_by_saraki__ddf7eb23c8813687539b0faa01ebeb18.jpg";
        sha256 = "sha256-MATV8oxRL1iLsWsVLTvT6AcSf3v5ha2FZCyBOXoIhrQ=";
      })
      (fetchImage {
        url = "https://cdn.donmai.us/original/58/83/__original_drawn_by_sakimori_hououbds__5883512fd347ba845a0a6fcf888e05cf.jpg";
        sha256 = "sha256-THZNxSOGQufVFvyAx+nAUbHsOIqJ147M1f/he8fF24A=";
      })
      (fetchImage {
        url = "https://cdn.donmai.us/original/5e/0b/__hatsune_miku_vocaloid_drawn_by_stuko__5e0b2a3416a5ed0ee19b5b1293091cbf.png";
        sha256 = "sha256-syTB7G5w4X3gNb0SUCyzBOPc/QyXXjclXMd3lni6ztc=";
      })
      (builtins.path {
        path = "${pkgs.mypkgs.pokemon-terminal}/lib/python3.10/site-packages/pokemonterminal/Images/Generation V - Unova/591.jpg";
      })
      (fetchImage {
        url = "https://cdn.donmai.us/original/13/39/__original_drawn_by_fuzichoco__13398173fff837a458cb9f196dde312b.png";
        sha256 = "sha256-oU5pBLKx9V5aJzwsFCgnrjdBq6hK1IPetYuvmOLp3Cs=";
      })
      (fetchImage {
        url = "https://cdn.donmai.us/original/a3/6f/__original_drawn_by_ogipote__a36f48fc91d06afb761c60ac42020ea4.jpg";
        sha256 = "sha256-GJwA7tfImVx3eXNBWUPJ2GtEPolFthsiZV5hgdgMSIA=";
      })
    ];
    dark = [
      (fetchImage {
        url = "https://i.pximg.net/img-original/img/2024/01/19/20/06/51/115301769_p0.jpg";
        sha256 = "sha256-TlkMJQ+jpiYroyB0/p44qiCM9ef/hbtGjAjVwxnWwfA=";
      })
      (fetchImage {
        url = "https://i.pximg.net/img-original/img/2024/10/03/00/01/48/122979717_p0.jpg";
        sha256 = "sha256-GeJZ28E9Y2cLYWkejIsr8iUlflbK4A5AY5HojlTUNLo=";
      })
      (fetchImage {
        url = "https://i.pximg.net/img-original/img/2023/01/27/23/28/32/104860495_p0.jpg";
        sha256 = "sha256-7Rp30eB/8DiSIdjyg1Y6Et+LAX93g27xLyNfhpJFqLQ=";
      })
      (fetchImage {
        url = "https://cdn.donmai.us/original/6b/78/__hakurei_reimu_touhou_drawn_by_kieta__6b7858c3798b5d0d1afb9f67bf43e2d5.jpg";
        sha256 = "sha256-55O9ufOistbm/6NYFuSEOOm9p1NUfzSS1js+F8vvTzU=";
      })
      (fetchImage {
        url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
        sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
      })
    ];
  };
in {
  stylix = rec {
    polarity = "light"; # “either”, “light”, “dark”
    image = builtins.head (builtins.getAttr polarity images);
  };
}
