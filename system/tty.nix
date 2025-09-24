{
  pkgs,
  lib,
  ...
}: {
  # services.greetd.vt = 2;
  # services.displayManager.ly.settings.tty = 2;
  # boot.kernelParams = ["console=tty1"];
  # services.journald.console = "/dev/tty3";

  services.gpm.enable = true; # enables mouse support in virtual consoles.

  # systemd.services = {
  #   "kmsconvt@tty1".enable = false;
  #   "kmsconvt@tty2".enable = false;
  #   "kmsconvt@tty3".enable = false;
  #   "autovt@tty1".enable = false;
  #   "autovt@tty2".enable = false;
  #   "autovt@tty3".enable = false;
  # };
  # services.kmscon = {
  #   enable = true;
  #   hwRender = true;
  #   fonts = [
  #     {
  #       package = pkgs.maple-mono.NF-CN;
  #       name = "Maple Mono NF CN";
  #     }
  #   ];
  #   extraOptions = "--term xterm-256color";
  #   extraConfig = "font-size=15";
  # };
}
## <sudo chvt N> to switch

