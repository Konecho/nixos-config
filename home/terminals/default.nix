{...}: {
  home.sessionVariables.TERMINAL = "wezterm";
  programs = {
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
    alacritty.enable = true;
    kitty.enable = true;
  };
}
