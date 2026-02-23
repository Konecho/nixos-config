{
  pkgs,
  lib,
  ...
}: {
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      # rootSearch = {
      #   searchFiles = false;
      # };
      # theme = {
      #   light.name = "Noctalia";
      #   dark.name = "Noctalia";
      # };
      # launcher_window.opacity = 0.85;
    };
  };
  wayland.windowManager.niri.settings.binds = {
    "Mod+D".spawn = ["vicinae" "toggle"];
    "Mod+V" = {
      _props.hotkey-overlay-title = "Clipboard Manager";
      spawn = ["vicinae" "vicinae://extensions/vicinae/clipboard/history"];
    };
  };
}
