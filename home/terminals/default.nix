{...}: {
  imports = [./wezterm.nix];
  home.sessionVariables.TERMINAL = "ghostty";
  programs = {
    wezterm.enable = true;
    alacritty.enable = true;
    ghostty.enable = true;
    kitty.enable = true;
    foot.enable = true;
    rio.enable = true;
  };
}
