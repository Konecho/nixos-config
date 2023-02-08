{ pkgs, ... }:

{
  boot.loader = {
    systemd-boot = { enable = true; consoleMode = "max"; };
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember-session --cmd Hyprland"; #sway
          # user = "mei";
        };
      };
    };
    journald.console = "/dev/tty1";
  };
}
