{
  pkgs,
  config,
  ...
}: {
  programs = {
    alacritty = {
      enable = true;
      settings = {
        # opacity = 0.8;
        font.size = 12;
      };
    };
  };
}
