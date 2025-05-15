{
  pkgs,
  config,
  lib,
  ...
}: {
  services.gpg-agent = {
    enable = true;
    # enableScDaemon = false;
    pinentry.package = pkgs.pinentry-curses;
  };
  programs.gpg = {
    enable = true;
    scdaemonSettings.disable-ccid = true;
  };
}
