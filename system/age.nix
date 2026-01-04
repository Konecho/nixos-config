{
  pkgs,
  lib,
  inputs,
  rootPath,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];
  nixpkgs.overlays = [inputs.agenix.overlays.default];
  environment.systemPackages = [pkgs.agenix];

  # import all agenix secrets
  age.secrets = let
    secrets = import (rootPath + /secrets/secrets.nix);
  in
    builtins.mapAttrs (name: attrs: {
      file = rootPath + /secrets/${name};
      owner = attrs.owner or "root";
      group = attrs.group or "root";
      mode = attrs.mode or "0400";
    })
    secrets;
  # config.age.secrets."example.age".path
}
