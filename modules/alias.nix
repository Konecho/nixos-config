{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule;
in {
  imports = [
    (mkAliasOptionModule ["user"] ["users" "users" config.mono.username])
  ];
}
