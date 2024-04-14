{
  pkgs,
  lib,
  config,
  rootPath,
  ...
}: let
  pm-csv = rootPath + /data/pmlist.csv;
in {
  home.shellAliases = lib.mkIf (config.programs.zellij.enable) {
    zellij = ''zellij -s "$(echo $POKEMON|awk -F',' '{print$2}')"'';
  };
  programs = {
    fish = {
      functions = {
        fish_greeting = ''
          random_pokemon
          echo $POKEMON|awk -F',' '{print$4}'|tr "'" " "| ${pkgs.pokemonsay}/bin/pokemonsay -N -D $POKEMON_NATIONAL_DEX_NUMBER
          config_local_git
        '';
        z = ''
          ${pkgs.zoxide}/bin/__zoxide_z $argv
          config_local_git
        '';
        random_pokemon = ''
          # set -g POKEMON_NATIONAL_DEX_NUMBER $(shuf -n 1 -i 1-898)

          set __DATE $(date +'%H*30+%M//2'|xargs calc|tr -d '[:space:]')
          if [ $__DATE = 0 ]
            set __DATE 720
          end
          set -g POKEMON_NATIONAL_DEX_NUMBER $__DATE

          set -g POKEMON $(sed -n {$POKEMON_NATIONAL_DEX_NUMBER}p ${pm-csv})
          config_local_git
        '';
        config_local_git = ''
          # if [ $(git rev-parse --is-inside-work-tree &| echo ) = 'true' ]
          #     git config user.name "$(echo $POKEMON|awk -F',' '{print$2}')"
          # end
        '';
        # global config is locked by nix
        # gitui = lib.mkBefore ''
        #   config_local_git
        # '';
      };
    };
    git.hooks.pre-commit =
      pkgs.writeShellScript "pre-commit-script.sh"
      ''
        id=$(date +'%H*30+%M//2'|xargs calc|tr -d '[:space:]')
        if [ $id -eq 0 ]; then id=720; fi
        PKM=$(sed -n $id"p" ${pm-csv})
        echo $PKM
        git config user.name "$(echo $PKM|awk -F',' '{print$2}')"
        git config --list
      '';
  };
}
