{
  inputs,
  config,
  pkgs,
  ...
}: let
  AmbxstPkgs =
    inputs.ambxst.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.packages = [AmbxstPkgs];
}
