{ pkgs, ... }:

{
  boot.loader = {
    systemd-boot = { enable = true; consoleMode = "auto"; };
    # efi.canTouchEfiVariables = true;
    # efi.efiSysMountPoint = "/boot/efi";
    # grub = {
    #   enable = true;
    #   efiSupport = true;
    #   device = "nodev";
    #   fsIdentifier = "label";
    #   # useOSProber = true;
    #   efiInstallAsRemovable = true;
    #   gfxmodeEfi = "1920x1080";
    #   # font = "${pkgs.hack-font}/share/fonts/hack/Hack-Regular.ttf";
    #   fontSize = 36;
    # };
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = [ "console=tty1" ];

  services = {
    greetd = {
      enable = true;
      vt = 7;
      settings = rec {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland"; #sway
          # user = "mei";
        };
      };
    };
    journald.console = "/dev/tty1";
    gpm.enable = true;
    kmscon = {
      enable = true;
      fonts = [{
        package = pkgs.maple-mono-SC-NF;
        name = "Maple Mono SC NF";
      }];
      extraOptions = "--term xterm-256color";
      extraConfig = "font-size=14";
    };
  };
  systemd.services."kmsconvt@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # programs.regreet = {
  #   enable = true;
  #   settings.default_session = { command = "Hyprland"; user = "mei"; };
  # };
}
