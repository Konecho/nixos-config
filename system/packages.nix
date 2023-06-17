{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
    helix
    # fbterm
    ccid
  ];
  services.printing.enable = true;
  services.printing.drivers = [pkgs.hplip];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.pcscd.enable = true;
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "canokey-udev-rules";
      text = ''
        # GnuPG/pcsclite
        SUBSYSTEM!="usb", GOTO="canokeys_rules_end"
        ACTION!="add|change", GOTO="canokeys_rules_end"
        ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", ENV{ID_SMARTCARD_READER}="1"
        LABEL="canokeys_rules_end"

        # FIDO2/U2F
        # note that if you find this line in 70-u2f.rules, you can ignore it
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", TAG+="uaccess", GROUP="plugdev", MODE="0660"

        # make this usb device accessible for users, used in WebUSB
        # change the mode so unprivileged users can access it, insecure rule, though
        SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", MODE:="0666"
        # if the above works for WebUSB (web console), you may change into a more secure way
        # choose one of the following rules
        # note if you use "plugdev", make sure you have this group and the wanted user is in that group
        #SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", GROUP="plugdev", MODE="0660"
        #SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/69-canokeys.rules";
    })
  ];
  # services.udev.extraRules = ''
  #   # GnuPG/pcsclite
  #   SUBSYSTEM!="usb", GOTO="canokeys_rules_end"
  #   ACTION!="add|change", GOTO="canokeys_rules_end"
  #   ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", ENV{ID_SMARTCARD_READER}="1"
  #   LABEL="canokeys_rules_end"

  #   # FIDO2/U2F
  #   # note that if you find this line in 70-u2f.rules, you can ignore it
  #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", TAG+="uaccess", GROUP="plugdev", MODE="0660"

  #   # make this usb device accessible for users, used in WebUSB
  #   # change the mode so unprivileged users can access it, insecure rule, though
  #   SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", MODE:="0666"
  #   # if the above works for WebUSB (web console), you may change into a more secure way
  #   # choose one of the following rules
  #   # note if you use "plugdev", make sure you have this group and the wanted user is in that group
  #   #SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", GROUP="plugdev", MODE="0660"
  #   #SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", TAG+="uaccess"
  # '';
  # for a WiFi printer
  services.avahi.openFirewall = true;
  # services.onlyoffice = {
  #   enable = true;
  #   hostname = "localhost";
  # };
  programs = {
    adb.enable = true;
    # hyprland.enable = true;
    # river.enable = true;
    # river.package = null;
    git.enable = true;
    fish.enable = true;
    ssh.knownHosts."github.com".publicKey = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
";
    # dconf.enable = true;
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   vimAlias = true;
    # };
  };
  virtualisation = {
    # anbox.enable = true;
    # libvirtd.enable = true;
    virtualbox = {
      host.enable = true;
      # guest.enable = true;
    };
    docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        # setSocketVariable = true;
      };
    };
    # waydroid.enable = true;
  };
  services.duplicati = {enable = true;};
  services.fwupd.enable = true;
  services.kmscon = {
    enable = true;
    fonts = [
      {
        package = pkgs.maple-mono-SC-NF;
        name = "Maple Mono SC NF";
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=14";
  };
}
