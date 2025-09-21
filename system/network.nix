{pkgs, ...}: {
  # services.v2ray = {
  #   enable = true;
  #   config = builtins.fromJSON (builtins.readFile ./v2ray.json);
  # };
  programs.ssh.knownHosts."github.com".publicKey = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
";

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
  networking = {
    networkmanager.enable = true; # <nmcli device wifi list/connect>

    # proxy.default = "http://127.0.0.1:7890/"; # 1080:=v2ray;7890:=clash

    proxy.noProxy = "127.0.0.1,.local,localhost,.cn";

    nameservers = ["127.0.0.1" "::1"];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";

    firewall.enable = false;
  };
  services.dae = {
    enable = true;
    configFile = "/home/config.dae";
  };
  services.dnscrypt-proxy2 = {
    enable = true;
    # Settings reference:
    # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      # Add this to test if dnscrypt-proxy is actually used to resolve DNS requests
      # query_log.file = "/var/log/dnscrypt-proxy/query.log";
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # server_names = [ ... ];
    };
  };
}
