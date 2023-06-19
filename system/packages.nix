{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
    helix
    # fbterm
    ccid
  ];

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
}
