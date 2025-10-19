{
  lib,
  username,
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule;
in {
  imports = [
    (mkAliasOptionModule ["user"] ["users" "users" username])
  ];
}
