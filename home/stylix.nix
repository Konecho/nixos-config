{pkgs, ...}: {
  # https://danth.github.io/stylix/options/hm.html
  stylix = {
    # image = pkgs.fetchurl {
    #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    # };
    image = pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/a3/6f/__original_drawn_by_ogipote__a36f48fc91d06afb761c60ac42020ea4.jpg";
      sha256 = "sha256-GJwA7tfImVx3eXNBWUPJ2GtEPolFthsiZV5hgdgMSIA=";
    };
    opacity = {terminal = 0.95;};
    polarity = "dark"; # “either”, “light”, “dark”
  };

  # pkgs.mypkgs.pokemon-terminal + "/lib/python3.10/site-packages/pokemonterminal/Images/Generation VI - Kalos/679.jpg";
}
