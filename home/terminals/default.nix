{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./alacritty.nix
    # ./wezterm.nix
  ];
  home.sessionVariables.TERMINAL = "alacritty";
  programs = {
    alacritty = {
      enable = true;
      settings = {
        opacity = 0.8;
        font.normal.family = "Maple Mono SC NF";
        font.size = 12;
      };
    };
  };
}
