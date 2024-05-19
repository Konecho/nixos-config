{...}: {
  programs.river = {
    enable = true;
    package = null;
  };
  programs.xwayland.enable = false;
}
