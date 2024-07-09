{
  pkgs,
  config,
  ...
}: {
  programs = {
    home-manager.enable = true;
    starship = {
      enable = true;
      enableTransience = true;
      settings =
        (
          removeAttrs (builtins.fromTOML (builtins.readFile "${pkgs.starship}/share/starship/presets/plain-text-symbols.toml"))
          ["os"]
        )
        // {
        };
    };
    thefuck.enable = true;
    rbw = {
      enable = true;
      settings.email = config.programs.git.userEmail;
      # settings.pinentry = pkgs.pinentry-rofi;
      settings.pinentry = pkgs.pinentry-curses;
    };
    rofi.enable = true;
    navi.enable = true;
    noti.enable = true; # <do-something>;noti> or <noti do-something>
    aria2.enable = true;
    atuin.enable = true; # <ctrl+r>
    broot.enable = true; # <br> tree-view search
    direnv = {
      enable = true;
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

    # [tui]
    vtm
    sc-im # 表格
    mc # 文件管理
    calc
    termusic

    (
      let
        python-packages = python-packages:
          with python-packages; [
            python-lsp-server
            autopep8
            black
            requests

            ptpython
          ];
        python-with-packages = python3.withPackages python-packages;
      in
        python-with-packages
    )

    rustup
    just
  ];
}
