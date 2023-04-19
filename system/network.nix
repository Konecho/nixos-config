{ ... }:

{
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # <nmcli device wifi list/connect>

  networking.proxy.default = "http://127.0.0.1:7890/"; #1080:=v2ray;7890:=clash
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,.cn";

  services.v2ray = {
    enable = true;
    config = builtins.fromJSON (builtins.readFile ./v2ray.json);
  };

  # services.create_ap = {
  #   enable = true;
  #   settings = {
  #     INTERNET_IFACE = "wlp4s0";
  #     PASSPHRASE = "00000000";
  #     SSID = "NixOS Hotspot";
  #     WIFI_IFACE = "wlp4s0";
  #   };
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
