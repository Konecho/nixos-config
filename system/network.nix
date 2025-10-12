{pkgs, ...}: {
  programs.ssh.knownHosts."github.com".publicKey = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
";

  networking = {
    networkmanager.enable = true; # <nmcli device wifi list/connect>
    firewall.enable = false;
  };
  services.dae = {
    enable = true;
    configFile = "/home/config.dae";
  };
}
