{
  pkgs,
  config,
  lib,
  ...
}: {
  services.gpg-agent = {
    enable = true;
    # enableScDaemon = false;
    pinentryPackage = pkgs.pinentry-curses;
  };
  programs.gpg = {
    enable = true;
    scdaemonSettings.disable-ccid = true;
  };
}
