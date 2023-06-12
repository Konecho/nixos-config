{...}: {
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # <nmcli device wifi list/connect>

  networking.proxy.default = "http://127.0.0.1:7890/"; #1080:=v2ray;7890:=clash
  # networking.proxy.default = "http://192.168.199.156:9080/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,.cn";

  nix.settings.substituters = ["https://mirrors.ustc.edu.cn/nix-channels/store"];

  # https://github.com/docker/docker-install/issues/150
  # virtualisation.docker.rootless.daemon.settings = {
  #   "http-proxy" = "";
  #   "https-proxy" = "";
  # };
  virtualisation.docker.daemon.settings = {
    "registry-mirrors" = [
      "https://docker.mirrors.ustc.edu.cn"
      "https://registry.docker-cn.com"
      "http://hub-mirror.c.163.com"
    ];
  };
  # services.v2ray = {
  #   enable = true;
  #   config = builtins.fromJSON (builtins.readFile ./v2ray.json);
  # };

  programs.clash-verge.enable = true;
  programs.clash-verge.autoStart = true;
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
