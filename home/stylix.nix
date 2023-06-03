{pkgs, ...}: {
  # https://danth.github.io/stylix/options/hm.html
  stylix = {
    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    };
    targets.vscode.enable = false;
    targets.gtk.enable = false;
    opacity = {terminal = 0.95;};
    polarity = "dark"; # “either”, “light”, “dark”
  };

  # pkgs.mypkgs.pokemon-terminal + "/lib/python3.10/site-packages/pokemonterminal/Images/Generation VI - Kalos/679.jpg";
}
