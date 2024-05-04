{pkgs, ...}: {
  home.shellAliases = {
    man = "batman";
    cat = "bat";
  };
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
    navi.enable = true;
    noti.enable = true; # <do-something>;noti> or <noti do-something>
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
    atuin.enable = true;
    broot.enable = true; # <br> tree-view search
    ## ls
    lsd = {
      enable = true;
      enableAliases = true;
      settings = {
        date = "relative";
        ignore-globs = [
          ".git"
          ".hg"
        ];
      };
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
    nb

    # hydrus

    ## network
    httpie
    nmap
    qrcp # share file
    socat # <echo 'cycle pause' | socat - /tmp/mpv-socket>
    wget
    # w3m

    ## file
    file
    trashy
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
    # unoconv # doc to docx

    ## rename files in editor
    vimv-rs # <vimv *.mp3>
    # renameutils # imv deurlname icp icmd qmv qcmd qcp

    ## system
    libnotify # <notify-send>
    ripgrep # <rg> grep
    procs # ps
    # comma # , <command> # moved to nix.nix
    just # make
    killall
    thefuck
    sysz

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
    ueberzugpp
  ];
}
