{
  pkgs,
  lib,
  ...
}: {
  programs.fresh-editor = {
    enable = true;
    settings.lsp.nix = {
      command = "${lib.getExe pkgs.nixd}";
      args = ["--semantic-tokens=true"];
      enabled = true;
      initialization_options.nixd = let
        getFlake = ''(builtins.getFlake (builtins.toString ./.))'';
      in {
        options = {
          home-manager.expr = ''${getFlake}.homeConfigurations.''${builtins.head (builtins.attrNames ${getFlake}.homeConfigurations)}.options'';
          nixos.expr = ''${getFlake}.nixosConfigurations.''${builtins.head (builtins.attrNames ${getFlake}.nixosConfigurations)}.options'';
        };
      };
    };
  };
}
