{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule;
in {
  imports = [
    (mkAliasOptionModule ["user-hm"] ["home-manager" "users" config.mono.username])
  ];
}
