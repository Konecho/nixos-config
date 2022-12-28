{ config, pkgs, ... }:

{
  # imports =
  #   [
  #     ./hardware-configuration.nix
  #     ./network.nix
  #     ./locale.nix
  #     ./users.nix
  #   ];

  nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  fileSystems."/nix/store" =
    {
      device = "/dev/disk/by-label/nix-store";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot2";
      fsType = "vfat";
    };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      # fsIdentifier = "label";
      # useOSProber = true;
      # efiInstallAsRemovable = true;
      gfxmodeEfi = "1920x1080";
      # font = "${pkgs.hack-font}/share/fonts/hack/Hack-Regular.ttf";
      fontSize = 36;
    };
  };

  boot.kernelParams = [ "console=tty1" ];

  services = {
    greetd = {
      enable = true;
      vt = 7;
      settings = rec {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time-format '%Y-%m-%d - %H:%M' --remember-session --cmd sway";
          user = "mei";
        };
      };
    };
    journald.console = "/dev/tty1";
  };

  security.doas.enable = true;

  # <LC_ALL=C xdg-user-dirs-update --force>
  environment = {
    etc."xdg/user-dirs.locale".text = "en_US";
    etc."xdg/user-dirs.defaults".text = ''
      DESKTOP=system/desktop
      DOWNLOAD=downloads
      TEMPLATES=system/templates
      PUBLICSHARE=system/public
      DOCUMENTS=documents
      MUSIC=media/music
      PICTURES=media/photos
      VIDEOS=media/video
    '';
    variables = {
      # EDITOR = "nvim";
      # BROWSER = "firefox";
      # TERMINAL = "wezterm";
    };
  };

  # To set up Sway using Home Manager, first you must enable Polkit in your nix configuration:
  security.polkit.enable = true;



  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

