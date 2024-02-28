{
  pkgs,
  lib,
  config,
  ...
}: {
  home.shellAliases = lib.mkIf (config.programs.zellij.enable) {
    zellij = ''zellij -s "$(echo $POKEMON|awk -F',' '{print$2}')"'';
  };
  programs = {
    fish = {
      functions = {
        fish_greeting = ''
          random_pokemon
          echo $POKEMON|awk -F',' '{print$4}'|tr "'" " "| ${pkgs.pokemonsay}/bin/pokemonsay -N -D $POKEMON_NATIONAL_DEX_NUMBER
        '';
        random_pokemon = ''
          # 898
          set -g POKEMON_NATIONAL_DEX_NUMBER $(shuf -n 1 -i 1-898)
          set -g POKEMON $(sed -n {$POKEMON_NATIONAL_DEX_NUMBER}p ${./pmlist.csv})
          git config user.name "$(echo $POKEMON|awk -F',' '{print$2}')"
        '';
      };
    };
  };
}
