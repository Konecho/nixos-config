{...}: {
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    default_input = "password";
    # numlock = true;
    # xinitrc = "niri";
    animation = "doom";
    # animation = "matrix";
    # bigclock = "en"; # don not enable with animation
  };
}
