{
  pkgs,
  config,
  lib,
  ...
}: {
  services.gpg-agent = {
    enable = true;
    # enableScDaemon = false;
    pinentryFlavor = "curses";
  };
  programs.gpg = {
    enable = true;
    scdaemonSettings.disable-ccid = true;
  };
}
