{
  pkgs,
  config,
  lib,
  ...
}: {
  programs = {
    home-manager.enable = true;
    starship = {
      enable = true;
      enableTransience = true;
      settings =
        (removeAttrs (builtins.fromTOML (
          builtins.readFile "${pkgs.starship}/share/starship/presets/plain-text-symbols.toml"
        )) ["os"])
        // {
          character = {
            error_symbol = "[x_x](bold red)";
            success_symbol = "[>_<](bold green)";
            vimcmd_symbol = "[0.0](bold green)";
          };
        };
    };
    thefuck.enable = true;
    rofi.enable = true;
    navi.enable = true;
    noti.enable = true; # <do-something>;noti> or <noti do-something>
    aria2.enable = true;
    atuin.enable = true; # <ctrl+r>
    broot.enable = true; # <br> tree-view search
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
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
    # [network]
    httpie
    nmap
    qrcp
    socat # <echo 'cycle pause' | socat - /tmp/mpv-socket>
    wget

    # [file]
    file
    entr
    fzf
    gdu
    xdg-utils # <xdg-open>

    # [system]
    sysz
    jq
    usbutils # <lsusb>

    # [tui]
    vtm
    sc-im # 表格
    mc # 文件管理
    calc
    termusic

    (python3.withPackages (py: with py; [requests ptpython]))

    # [development]
    devenv
    rustup
    just
  ];
}
