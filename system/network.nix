{config, ...}: {
  programs.ssh.knownHosts."github.com".publicKey = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
";

  xdg.portal.config.common.default = "*";
  time.timeZone = "Asia/Shanghai";
  # time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "zh_CN.UTF-8";
  # i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    networkmanager.enable = true; # <nmcli device wifi list/connect>
    firewall.enable = false;
  };
  services.dae = {
    enable = true;
    configFile = "${config.user.home}/config.dae";
  };
}
