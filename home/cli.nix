{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    navi.enable = true;
    noti.enable = true; # <do-something>;noti> or <noti do-somethingdo-somethind>>
    # rbw.enable = true;
    bat = {
      enable = true; # cat
      ## https://github.com/eth-p/bat-extras
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
        batpipe
        prettybat
      ];
    };
    zoxide.enable = true; # <z> cd
    bottom.enable = true; # <btm> top
    mcfly.enable = true; # <ctrl-r>
    broot.enable = true; # <br> tree-view search
    ## ls
    lsd = {
      enable = true;
      enableAliases = true;
    };
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
    (nb.overrideAttrs (finalAttrs: previousAttrs: {
      postInstall = ''
        installShellCompletion --cmd nb etc/nb-completion.{bash,zsh,fish}
      '';
    })) # notebook

    ## network
    httpie
    nmap
    qrcp # share file
    socat # <echo 'cycle pause' | socat - /tmp/mpv-socket>
    wget
    # w3m

    ## file
    entr # watch file
    fd # find
    fzf
    du-dust # <dust> du
    gdu
    xdg-utils # <xdg-open>
    # unrar
    # unzip
    # p7zip # <7z>
    # poppler_utils # <pdftotext>
    # highlight

    ## system
    libnotify # <notify-send>
    ripgrep # <rg> grep
    procs # ps
    comma # , <command>
    just # make
    killall

    ## text
    logtop # count line
    jq # parse json
    sd # sed
    # zscroll

    ## multi media
    pavucontrol
    wf-recorder
    # mediainfo
    # ffmpeg
    # yt-dlp

    ## image
    # chafa
    # timg
    # imagemagick
    # ueberzug
  ];
}
