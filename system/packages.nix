{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
    helix
    # fbterm
    ccid
  ];

  programs = {
    adb.enable = true;
    # hyprland.enable = true;
    # river.enable = true;
    # river.package = null;
    git.enable = true;
    fish.enable = true;
    # dconf.enable = true;
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   vimAlias = true;
    # };
  };
}
