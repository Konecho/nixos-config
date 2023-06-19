{pkgs, ...}: let
  logVtNum = 1;
  graphVtNum = 7;
in {
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "auto";
    };
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

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "95%";
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = ["console=tty${builtins.toString logVtNum}"];

  services = {
    greetd = {
      enable = true;
      vt = graphVtNum;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.fish}/bin/fish";
        };
      };
    };
    journald.console = "/dev/tty${builtins.toString logVtNum}";
    gpm.enable = true;
  };
  systemd.services."kmsconvt@tty${builtins.toString logVtNum}".enable = false;
  systemd.services."autovt@tty${builtins.toString logVtNum}".enable = false;

  # programs.regreet = {
  #   enable = true;
  #   settings.default_session = { command = "Hyprland"; user = "mei"; };
  # };
}
