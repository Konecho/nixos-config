{pkgs, ...}: {
  # https://danth.github.io/stylix/options/hm.html
  stylix = {
    # image = pkgs.fetchurl {
    #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    # };
    image = pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/a3/01/__hatsune_miku_vocaloid_drawn_by_asahi_kuroi__a301e57c69fbcc4e760a059b14d102c9.png";
      sha256 = "sha256-I9Cw7U091kDqASV8wS7OysRZ78ElD65mU/fHb295T5Q=";
    };
    opacity = {terminal = 0.95;};
    polarity = "dark"; # “either”, “light”, “dark”
  };

  # pkgs.mypkgs.pokemon-terminal + "/lib/python3.10/site-packages/pokemonterminal/Images/Generation VI - Kalos/679.jpg";
}
