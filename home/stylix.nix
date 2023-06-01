{pkgs, ...}: {
  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };
  stylix.targets.vscode.enable = false;
  # pkgs.mypkgs.pokemon-terminal + "/lib/python3.10/site-packages/pokemonterminal/Images/Generation VI - Kalos/679.jpg";
}
