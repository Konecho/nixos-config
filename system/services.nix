{
  pkgs,
  lib,
  ...
}: {
  programs = {
    adb.enable = true;
    # hyprland.enable = true;
    # river.enable = true;
    # river.package = null;
    # dconf.enable = true;
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   vimAlias = true;
    # };
  };
  services = {
    # printing = {
    #   enable = true;
    #   drivers = [pkgs.hplip];
    # };
    # avahi = {
    #   enable = true;
    #   nssmdns = true;
    #   openFirewall = true;
    # };
    udisks2.enable = true;
    pcscd.enable = true;
    # udev.packages = [
    #   (pkgs.writeTextFile {
    #     name = "canokey-udev-rules";
    #     text = ''
    #       # GnuPG/pcsclite
    #       SUBSYSTEM!="usb", GOTO="canokeys_rules_end"
    #       ACTION!="add|change", GOTO="canokeys_rules_end"
    #       ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", ENV{ID_SMARTCARD_READER}="1"
    #       LABEL="canokeys_rules_end"

    #       # FIDO2/U2F
    #       # note that if you find this line in 70-u2f.rules, you can ignore it
    #       KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", TAG+="uaccess", GROUP="plugdev", MODE="0660"

    #       # make this usb device accessible for users, used in WebUSB
    #       # change the mode so unprivileged users can access it, insecure rule, though
    #       SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", MODE:="0666"
    #       # if the above works for WebUSB (web console), you may change into a more secure way
    #       # choose one of the following rules
    #       # note if you use "plugdev", make sure you have this group and the wanted user is in that group
    #       #SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", GROUP="plugdev", MODE="0660"
    #       #SUBSYSTEMS=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="42d4", TAG+="uaccess"
    #     '';
    #     destination = "/etc/udev/rules.d/69-canokeys.rules";
    #   })
    # ];
    duplicati = {
      enable = true;
      dataDir = "/db/duplicati";
    };
    fwupd.enable = true;
    kmscon = {
      enable = true;
      fonts = [
        {
          package = pkgs.maple-mono-SC-NF;
          name = "Maple Mono SC NF";
        }
      ];
      extraOptions = "--term xterm-256color";
      extraConfig = "font-size=15";
    };
    # davfs2.enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  # services.xserver.displayManager.startx.enable = true;
}
