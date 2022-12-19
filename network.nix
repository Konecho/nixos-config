{ ... }:

{
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  networking.proxy.default = "http://127.0.0.1:1080/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,.cn";

  services.v2ray = {
    enable = true;
    config = {
      inbounds = [{
        port = 1080;
        listen = "127.0.0.1";
        protocol = "http";
      }];
      outbounds = [{
        protocol = "vmess";
        settings = {
          vnext = [{
            address = "173.82.7.19";
            port = 32123;
            users = [{
              alterId = 0;
              encryption = "";
              flow = "";
              id = "ffc9e515-2b84-42a4-97ef-07c3e26cbae1";
              level = 8;
              security = "auto";
            }];
          }];
        };
        streamSettings = {
          kcpSettings = {
            congestion = false;
            downlinkCapacity = 100;
            header = { type = "dtls"; };
            mtu = 1350;
            readBufferSize = 1;
            tti = 50;
            uplinkCapacity = 12;
            writeBufferSize = 1;
          };
          network = "kcp";

        };
      }];
    };
  };

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "wlp4s0";
      PASSPHRASE = "00000000";
      SSID = "NixOS Hotspot";
      WIFI_IFACE = "wlp4s0";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
