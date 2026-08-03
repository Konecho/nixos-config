{...}: {
  imports = [./wezterm.nix];
  home.sessionVariables.TERMINAL = "ghostty";
  programs = {
    wezterm.enable = true;
    alacritty.enable = true;
    ghostty.enable = true;
    ghostty.settings.background-opacity = 0.85;
    kitty.enable = true;
    foot.enable = true;
    rio.enable = true;
  };
}
