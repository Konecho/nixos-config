# polarity = "light"; # “either”, “light”, “dark”
pkgs: {
  light = [
    (pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/5e/0b/__hatsune_miku_vocaloid_drawn_by_stuko__5e0b2a3416a5ed0ee19b5b1293091cbf.png";
      sha256 = "sha256-syTB7G5w4X3gNb0SUCyzBOPc/QyXXjclXMd3lni6ztc=";
    })
    (builtins.path {
      path = "${pkgs.mypkgs.pokemon-terminal}/lib/python3.10/site-packages/pokemonterminal/Images/Generation V - Unova/591.jpg";
    })
    (pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/13/39/__original_drawn_by_fuzichoco__13398173fff837a458cb9f196dde312b.png";
      sha256 = "sha256-oU5pBLKx9V5aJzwsFCgnrjdBq6hK1IPetYuvmOLp3Cs=";
    })
    (pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/a3/6f/__original_drawn_by_ogipote__a36f48fc91d06afb761c60ac42020ea4.jpg";
      sha256 = "sha256-GJwA7tfImVx3eXNBWUPJ2GtEPolFthsiZV5hgdgMSIA=";
    })
  ];
  dark = [
    (pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    })
  ];
}
