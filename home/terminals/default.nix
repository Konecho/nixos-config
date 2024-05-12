{...}: {
  imports = [
    ./alacritty.nix
    ./wezterm.nix
  ];
  home.sessionVariables.TERMINAL = "wezterm";
}
