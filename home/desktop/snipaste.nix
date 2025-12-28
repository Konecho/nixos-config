{
  pkgs,
  rootPath,
  ...
}: {
  home.packages = with pkgs; [wl-clipboard-rs];
  programs.fish.functions.snipaste = builtins.readFile (rootPath + "/data/snipaste.fish");
  programs.niri.settings.binds."F3".action.spawn = ["fish" "-c" "snipaste"];
  programs.niri.settings.window-rules = [
    {
      matches = [{app-id = "snipaste-popup";}];
      open-floating = true;
      open-focused = false;
    }
  ];
  programs.swayimg.enable = true;
  programs.swayimg.settings = {
    "info.viewer" = {
      top_left = "none";
      top_right = "none";
      bottom_left = "none";
      bottom_right = "none";
    };
    "keys.viewer" = {
      MouseLeft = "exit";
    };
  };
}
