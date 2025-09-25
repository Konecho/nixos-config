{
  config,
  inputs,
  pkgs,
  system,
  username,
  rootPath,
  ...
}: {
  imports =
    [
      inputs.nixos-wsl.nixosModules.wsl
      inputs.vscode-server.nixosModules.default
    ]
    ++ (map (path: rootPath + path) [
      /system/core.nix
      /system/misc.nix
      /system/nix.nix
      # /system/age
    ]);
  nixpkgs.overlays = [
    inputs.nixgl.overlay
  ];
  # services.xserver.enable=true;
  hardware.graphics.enable = true;
  # hardware.opengl.extraPackages = with pkgs; [mesa.drivers];
  wsl = {
    enable = true;
    defaultUser = "${username}";
    # 创建软件的桌面快捷方式
    # startMenuLaunchers = true;
    extraBin = with pkgs; [
      {src = "${coreutils}/bin/uname";}
      {src = "${coreutils}/bin/dirname";}
      {src = "${coreutils}/bin/readlink";}
      {src = "${coreutils}/bin/cat";}
      {src = "${coreutils}/bin/sed";}
      {src = "/run/current-system/sw/bin/sed";}
    ];
    usbip = {
      enable = true;
      autoAttach = [
      ];
    };
    interop.register = true;
    # useWindowsDriver = true;
    # docker-desktop.enable = true;
    # wslConf.user.default = "${username}";
  };
  systemd.user = {
    paths.vscode-remote-workaround = {
      wantedBy = ["default.target"];
      pathConfig.PathChanged = "%h/.vscode-server/bin";
    };
    services.vscode-remote-workaround.script = ''
      for i in ~/.vscode-server/bin/*; do
        echo "Fixing vscode-server in $i..."
        ln -sf ${pkgs.nodejs}/bin/node $i/node
      done
    '';
  };
  users.groups.plugdev.members = ["${username}"];
  # users.users."${username}".extraGroups = ["plugdev"]; # not work
  networking.proxy.default = "http://192.168.80.1:7890";
  services.udev.extraRules = ''
  '';
  networking = {
    nameservers = ["127.0.0.1" "::1"];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
  };
  # wsl
  # wsl.wslConf.
  wsl.wslConf.network.generateResolvConf = false;
  # networking.resolvconf.useLocalResolver = true;
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

  environment.systemPackages = with pkgs; [
    wsl-open
    # obsidian

    # nixgl.nixGLIntel
    # glxinfo

    wget # for nix-ld code-server

    # gnuradio
  ];

  nix.gc.automatic = true;
  nix.gc.dates = "18:00";
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };
  services.vscode-server = {
    enable = true;
    # enableFHS = true;
  };
  fonts.fontconfig.enable = true;
  # qt.enable = true;
  # qt.platformTheme = "lxqt";
  # qt.style = "adwaita";
}
