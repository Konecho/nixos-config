{pkgs, ...}: {
  imports = [
    ./librewolf.nix
    ./zen-browser.nix
  ];
  programs.qutebrowser.enable = true;
  home.sessionVariables.BROWSER = "qutebrowser";
  home.packages = with pkgs; [
    # surf
    # microsoft-edge
    # google-chrome
    # vivaldi
    # firefox
    # firefox-devedition
    # librewolf
  ];
}
