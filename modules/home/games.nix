{pkgs, ...}: {
  home.packages = with pkgs; [
    # steam-tui
    # steamcmd
    steam
  ];
  # programs.lutris = {
  #   enable = true;
  # };
}
