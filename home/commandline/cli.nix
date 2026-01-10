{
  pkgs,
  config,
  lib,
  ...
}: {
  programs = {
    home-manager.enable = true;
    # thefuck.enable = true;
    # rofi.enable = true;
    navi.enable = true;
    noti.enable = true; # <do-something>;noti> or <noti do-something>
    aria2.enable = true;
    atuin.enable = true; # <ctrl+r>
    broot.enable = true; # <br> tree-view search
    carapace.enable = true;

    ## <tldr>
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };
  };
  home.packages = with pkgs; [
    wget
    file
    xdg-utils # <xdg-open>
    sysz
    usbutils # <lsusb>
    witr

    jq
    (python3.withPackages (
      p:
        with p; [
          pygments
          ptpython
          # xd deps
          beautifulsoup4
          requests
          prompt-toolkit
          wcwidth
        ]
    ))

    devenv
  ];
}
