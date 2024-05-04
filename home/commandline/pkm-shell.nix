{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  home.shellAliases = lib.mkIf (config.programs.zellij.enable) {
    zellij = ''zellij -s "$(cat $XDG_RUNTIME_DIR/pokemon)"'';
  };
  programs = {
    fish.functions.fish_greeting = ''
      catimg-pokemon -f ${inputs.pokesprite}
    '';
    nushell.configFile.text = lib.mkAfter ''
      def greet [] {
        catimg-pokemon -f ${inputs.pokesprite}
      }
      greet
    '';
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
