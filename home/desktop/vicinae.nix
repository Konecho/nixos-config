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
  programs.niri.settings.binds."Mod+D".action.spawn = ["vicinae" "toggle"];
  programs.niri.settings.binds."Mod+V".action.spawn = ["vicinae" "vicinae://extensions/vicinae/clipboard/history"];
}
