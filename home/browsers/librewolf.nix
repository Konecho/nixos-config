{
  inputs,
  pkgs,
  ...
}: let
  rycee-addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  stylix.targets.librewolf.enable = false;
  programs = {
    librewolf = {
      enable = true;
      languagePacks = ["en-GB" "zh-CN"];
      profiles.default.extensions.packages = import ./firefox-addons.nix {
        inherit rycee-addons;
        inherit (pkgs) fetchgit stdenv zip;
      };
    };
  };
}
