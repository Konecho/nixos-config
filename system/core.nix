{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.binsh = "${lib.getExe pkgs.dash}";

  security.sudo.enable = lib.mkDefault false;
  security.sudo.execWheelOnly = true;
  security.doas.enable = true;
  security.doas.extraRules = [
    {
      groups = ["wheel"];
      persist = true;
      keepEnv = true;
    }
  ];

  environment.systemPackages = with pkgs; [
    home-manager
    helix

    (lib.mkIf (!config.security.sudo.enable && config.security.doas.enable) (
      writeScriptBin "sudo" ''exec ${lib.getExe doas} "$@"''
    ))
  ];

  programs = {
    git.enable = true;
    fish.enable = true;
  };
}
