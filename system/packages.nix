{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
    # fbterm
  ];
  programs = {
    adb.enable = true;
    hyprland.enable = true;
    river.enable = true;
    river.package = null;
    git.enable = true;
    fish.enable = true;
    ssh.knownHosts."github.com".publicKey = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
";
    # dconf.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
  virtualisation = {
    # anbox.enable = true;
    # libvirtd.enable = true;
    # virtualbox.host.enable = true;
    # virtualbox.guest.enable = true;
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
