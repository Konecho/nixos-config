{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    unzip
    p7zip # <7z>
    rnix-lsp
    home-manager
  ];
  programs = {
    adb.enable = true;
    sway.enable = true;
    git = {
      enable = true;
    };
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
    docker.enable = true;
    # waydroid.enable = true;
  };
}
