{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./network.nix
      ./locale.nix
      ./users.nix
    ];

  nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.autoUpgrade = {
    enable = true;
    channel = "https://mirrors.ustc.edu.cn/nix-channels/nixos-22.11";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      fsIdentifier = "label";
      useOSProber = true;
      # efiInstallAsRemovable = true;
      gfxmodeEfi = "1920x1080";
      # font = "${pkgs.hack-font}/share/fonts/hack/Hack-Regular.ttf";
      fontSize = 36;
    };
  };

  boot.kernelParams = [ "console=tty1" ];

  services.greetd = {
    enable = true;
    vt = 7;
    settings = rec {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway";
        user = "mei";
      };
    };
  };

  services.journald.console = "tty1";

  programs.sway.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # qemu
  # virtualbox
  virtualisation = {
    # anbox.enable = true;
    docker.enable = true;
    # waydroid.enable = true;
  };

  # nixpkgs.config.allowUnfree = true;
  # security.polkit.enable = true;
  security.doas.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    unzip
    p7zip # <7z>
    # unrar # is not unfree

    # kitty
    # wezterm
    # alacritty
    rnix-lsp
    home-manager
  ];

  # <LC_ALL=C xdg-user-dirs-update --force>
  environment.etc."xdg/user-dirs.locale".text = "en_US";
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=system/desktop
    DOWNLOAD=downloads
    TEMPLATES=system/templates
    PUBLICSHARE=system/public
    DOCUMENTS=documents
    MUSIC=media/music
    PICTURES=media/photos
    VIDEOS=media/video
  '';

  programs = {
    adb.enable = true;
    git = {
      enable = true;
    };
    # dconf.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };

  environment.variables = {
    # EDITOR = "nvim";
    # BROWSER = "firefox";
    # TERMINAL = "wezterm";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

