{
  pkgs,
  rootPath,
  lib,
  config,
  inputs,
  ...
}: let
  patchPathInFish = p: builtins.replaceStrings ["\$\{"] ["\{\$"] p;
in {
  imports =
    map (path: rootPath + path) [
      /home/common.nix
      /home/nix.nix
      /home/git.nix

      /home/commandline/default.nix

      /home/desktop/fonts.nix
    ]
    ++ [inputs.agenix.homeManagerModules.default];
  programs.helix.settings.theme = "base16";
  programs.helix.themes.base16 = {
    inherits = "github_light";
    "ui.background" = {};
    "ui.statusline.normal" = {
      bg = "blue";
      fg = "white";
    };
  };
  age.secrets.test = {
    file = rootPath + /secrets/test.age;
  };
  programs = {
    fish.functions.fish_greeting = patchPathInFish ''
      cat ${config.age.secrets.test.path}
    '';
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };
}
