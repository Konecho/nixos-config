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
      font = {
        size = 10;
      };
      popToRootOnClose = false;
      rootSearch = {
        searchFiles = false;
      };
      theme = {
        name = "matugen";
      };
      window = {
        csd = true;
        opacity = 0.95;
        rounding = 10;
      };
    };
  };
  programs.niri.settings.binds."Mod+D".action.spawn = ["vicinae" "toggle"];
  programs.niri.settings.binds."Mod+V".action.spawn = ["vicinae" "vicinae://extensions/vicinae/clipboard/history"];
}
