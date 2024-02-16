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
        font.normal.family = "Maple Mono SC NF";
        font.size = 12;
      };
    };
  };
}
