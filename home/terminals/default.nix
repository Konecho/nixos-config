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
        background-opacity = 0.85;
        background-blur = true;
      };
    };
    kitty.enable = true;
    foot.enable = true;
  };
}
