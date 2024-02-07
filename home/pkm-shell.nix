{pkgs, ...}: {
  home.shellAliases = {
    zellij = ''zellij -s "$(echo $POKEMON|awk -F',' '{print$2}')"'';
  };
  programs = {
    fish = {
      functions = {
        # zellij = ''
        #   ${pkgs.zellij}/bin/zellij -s "$(echo $POKEMON|awk -F',' '{print$2}') $argv"
        # '';
        fish_greeting = ''
          random_pokemon
          echo $POKEMON|awk -F',' '{print$4}'|tr "'" " "| ${pkgs.pokemonsay}/bin/pokemonsay -N
        '';
        random_pokemon = ''
          set -g POKEMON $(shuf ~/scripts/pmlist.csv -n 1)
        '';
        gitui = ''
          # random_pokemon
          # git config user.name "$(echo $POKEMON|awk -F',' '{print$2}')"
          ssh-add ~/.ssh/id_ed25519 2> /dev/null
          ${pkgs.gitui}/bin/gitui
        '';
      };
    };
  };
}
