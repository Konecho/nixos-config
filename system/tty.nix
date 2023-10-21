{pkgs, ...}: let
  logVtNum = 1;
  graphVtNum = 7;
in {
  boot.kernelParams = ["console=tty${builtins.toString logVtNum}"];
  services = {
    greetd = {
      enable = false;
      vt = graphVtNum;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.fish}/bin/fish";
        };
      };
    };
    journald.console = "/dev/tty${builtins.toString logVtNum}";
    gpm.enable = true; # enables mouse support in virtual consoles.
  };
  systemd.services."kmsconvt@tty${builtins.toString logVtNum}".enable = false;
  systemd.services."autovt@tty${builtins.toString logVtNum}".enable = false;

  # programs.regreet = {
  #   enable = true;
  #   settings.default_session = { command = "Hyprland"; user = "mei"; };
  # };
}
## <sudo chvt N> to switch

