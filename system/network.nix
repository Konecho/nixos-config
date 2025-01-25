{pkgs, ...}: {
  networking.networkmanager.enable = true; # <nmcli device wifi list/connect>

  networking.proxy.default = "http://127.0.0.1:7890/"; # 1080:=v2ray;7890:=clash

  networking.proxy.noProxy = "127.0.0.1,.local,localhost,.cn";

  # services.v2ray = {
  #   enable = true;
  #   config = builtins.fromJSON (builtins.readFile ./v2ray.json);
  # };

  programs.ssh.knownHosts."github.com".publicKey = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
";

  networking.firewall.enable = false;

  # services.mihomo = {
  #   enable = true;
  #   # webui = "";
  #   configFile = pkgs.writeTextFile {
  #     name = "config.yaml";
  #     text = ''
  #       mixed-port: 7890
  #       external-controller: 127.0.0.1:9090
  #     '';
  #   };
  #   # authentication:
  #   # - "user:supersecret"
  # };
}
