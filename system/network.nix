{ ... }:

{
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # <nmcli device wifi list/connect>

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
      outbounds = [
        {
          tag = "proxy";
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
        }
        {
          tag = "block";
          protocol = "blackhole";
        }
        {
          tag = "direct";
          protocol = "freedom";
        }
      ];
      routing = {
        domainStrategy = "IpIfNonMatch";
        rules = builtins.fromJSON ''
          [
            {
              "type": "field",
              "outboundTag": "proxy",
              "domain": [
                "#以下三行是GitHub网站，为了不影响下载速度走代理",
                "github.com",
                "githubassets.com",
                "githubusercontent.com"
              ]
            },
            {
              "type": "field",
              "outboundTag": "block",
              "domain": [
                "#阻止CrxMouse鼠标手势收集上网数据",
                "mousegesturesapi.com"
              ]
            },
            {
              "type": "field",
              "outboundTag": "direct",
              "domain": [
                "bitwarden.com",
                "bitwarden.net",
                "baiyunju.cc",
                "letsencrypt.org",
                "adblockplus.org",
                "safesugar.net",
                "#下两行谷歌广告",
                "googleads.g.doubleclick.net",
                "adservice.google.com",
                "#【以下全部是geo预定义域名列表】",
                "#下一行是所有私有域名",
                "geosite:private",
                "#下一行包含常见大陆站点域名和CNNIC管理的大陆域名，即geolocation-cn和tld-cn的合集",
                "geosite:cn",
                "#下一行包含所有Adobe旗下域名",
                "geosite:adobe",
                "#下一行包含所有Adobe正版激活域名",
                "geosite:adobe-activation",
                "#下一行包含所有微软旗下域名",
                "geosite:microsoft",
                "#下一行包含微软msn相关域名少数与上一行微软列表重复",
                "geosite:msn",
                "#下一行包含所有苹果旗下域名",
                "geosite:apple",
                "#下一行包含所有广告平台、提供商域名",
                "geosite:category-ads-all",
                "#下一行包含可直连访问谷歌网址，需要替换为加强版GEO文件，如已手动更新为加强版GEO文件，删除此行前面的#号使其生效",
                "#geosite:google-cn",
                "#下一行包含可直连访问苹果网址，需要替换为加强版GEO文件，如已手动更新为加强版GEO文件，删除此行前面的#号使其生效",
                "#geosite:apple-cn"
              ]
            },
            {
              "type": "field",
              "outboundTag": "proxy",
              "domain": [
                "#GFW域名列表",
                "#geosite:gfw",
                "geosite:greatfire"
              ]
            },
            {
              "type": "field",
              "port": "0-65535",
              "outboundTag": "proxy"
            }
          ]
        '';
        balancingRule = [ ];
      };
    };

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
