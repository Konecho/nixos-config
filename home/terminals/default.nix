{...}: {
  home.sessionVariables.TERMINAL = "ghostty";
  programs = {
    wezterm.enable = true;
    # alacritty.enable = true;
    ghostty = {
      enable = true;
      settings = {
        # window-decoration = "none";
        mouse-hide-while-typing = true;
      };
    };
    kitty.enable = true;
    foot.enable = true;
  };
}
