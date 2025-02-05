{...}: {
  home.sessionVariables.TERMINAL = "ghostty";
  programs = {
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
    # alacritty.enable = true;
    ghostty = {
      enable = true;
      settings = {
        window-decoration = false;
        mouse-hide-while-typing = true;
      };
    };
    kitty.enable = true;
  };
}
