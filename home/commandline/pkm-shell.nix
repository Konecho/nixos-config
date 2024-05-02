{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  home.shellAliases = lib.mkIf (config.programs.zellij.enable) {
    zellij = ''zellij -s "$(echo $POKEMON|awk -F',' '{print$2}')"'';
  };
  programs = {
    fish = {
      functions = {
        fish_greeting = ''
          catimg-pokemon -f ${inputs.pokesprite}
        '';
        z = ''
          ${pkgs.zoxide}/bin/__zoxide_z $argv
        '';
      };
    };
    git.hooks.pre-commit =
      pkgs.writeShellScript "pre-commit-script.sh"
      ''
        if [ -f $XDG_RUNTIME_DIR/pokemon ]; then
          git config user.name "$(cat $XDG_RUNTIME_DIR/pokemon)"
          git config --list
        fi
      '';
  };
}
