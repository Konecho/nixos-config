{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./niri.nix
    ./river.nix
    ./cosmic.nix
  ];
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = lib.mkDefault {
        command = builtins.concatStringsSep " " [
          "tuigreet"
          "--user-menu"
          "--user-menu-min-uid 1000"
          "--user-menu-max-uid 1001"
          "--time"
          # ''--time --time-format="%x, %A, %H:%M"''
          "--asterisks "
          "--power-shutdown 'shutdown -h now'"
          "--cmd niri-session"
          # "--cmd river"
        ];
      };
    };
  };
}
