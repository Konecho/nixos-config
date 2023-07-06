{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    home-manager
    helix
    # fbterm
    ccid
    (lib.mkIf (! config.security.sudo.enable
      && config.security.doas.enable)
    (writeScriptBin "sudo" ''exec doas "$@"''))

    sing-box
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
