{pkgs, ...}: {
  home.shellAliases = {man = "batman";};
  programs = {
    navi.enable = true;
    bat = {
      enable = true; # cat
      # https://github.com/eth-p/bat-extras
      extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch batpipe prettybat];
    };
    zellij.enable = true; # tmux
    zoxide.enable = true; # <z> cd
    bottom.enable = true; # <btm> top
    mcfly.enable = true; # <ctrl-r>
    broot.enable = true; # <br> tree-view search
    lf = {
      enable = true;
      previewer = {
        keybinding = "i";
        source = "${pkgs.ctpv}/bin/ctpv";
      };
    };
    # ls
    lsd = {
      enable = true;
      enableAliases = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    # <tldr>
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
    ## [[terminal]]
    zscroll
    wget
    fd # find
    fzf
    ripgrep # <rg> grep
    procs # ps
    comma # , <command>

    jq
    just # make
    sd # sed
    du-dust # <dust> du
    gdu

    ## lib for <lf>
    # unrar
    # unzip
    # p7zip # <7z>
    # w3m
    # poppler_utils # <pdftotext>
    # highlight
    # mediainfo
    # chafa
    # timg

    ## [[multi-media]]
    xdg-utils # <xdg-open>
    pamixer
    pavucontrol
    wf-recorder
    ffmpeg
    yt-dlp

    socat # <echo 'cycle pause' | socat - /tmp/mpv-socket>

    imagemagick
    # ueberzug
  ];
}
