{pkgs, ...}: {
  # https://danth.github.io/stylix/options/hm.html

  stylix = let
    polarity = "light"; # “either”, “light”, “dark”
  in {
    image = builtins.head (builtins.getAttr polarity (import ./wallpapers.nix pkgs));
    inherit polarity;
    opacity = {terminal = 0.95;};
  };

  # pkgs.mypkgs.pokemon-terminal + "/lib/python3.10/site-packages/pokemonterminal/Images/Generation VI - Kalos/679.jpg";
}
