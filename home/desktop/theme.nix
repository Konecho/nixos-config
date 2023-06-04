{pkgs, ...}: {
  home.pointerCursor = {
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 24;
    gtk.enable = true;
  };
  gtk = {
    enable = true;
    # cursorTheme = { };
    # theme = {
    #   name = "Pop";
    #   package = pkgs.pop-gtk-theme;
    # };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-solarized-gtk-theme;
    };
  };
}
