{...}: {
  services.linux-wallpaperengine = {
    enable = true;
    assetsPath = "/home/.local/share/Steam/steamapps/common/wallpaper_engine/assets";
    wallpapers = [
      {
        monitor = "HDMI-A-1";
        wallpaperId = "2902931482";
      }
    ];
  };
}
