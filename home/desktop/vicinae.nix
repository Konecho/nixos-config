{
  pkgs,
  lib,
  ...
}: {
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      faviconService = "twenty";
      rootSearch = {
        searchFiles = false;
      };
      theme = {
        name = "Noctalia";
      };
    };
  };
  wayland.windowManager.niri.settings.binds = {
    "Mod+D".spawn = ["vicinae" "toggle"];
    "Mod+V".spawn = ["vicinae" "vicinae://extensions/vicinae/clipboard/history"];
  };
}
