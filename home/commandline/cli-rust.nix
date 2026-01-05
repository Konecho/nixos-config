{
  pkgs,
  config,
  ...
}: {
  home.shellAliases = {
    man = "batman";
    cat = "bat";
    top = "btm";
    # tmux = "zellij";
    # cd = "z";
    # find = "fd";
    # du = "dust";
    # grep = "rg";
    # ps = "procs";
    # sed = "sd";
    # rm = "trash put";
    # cut = "hck";
  };
  home.packages = with pkgs; [
    hck
    fd
    dust
    ripgrep
    procs
    sd
    trashy
    just
    rustup
  ];
  programs = {
    bat.enable = true; # cat
    ## https://github.com/eth-p/bat-extras
    bat.extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
      batpipe
      prettybat
    ];
    skim = {
      # <sk> replace fzf
      enable = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'lsd --tree {} | head -200'"
      ];
    };
    zoxide.enable = true;
    bottom.enable = true;
    lsd.enable = true;
    lsd.settings = {
      date = "relative";
    };
    zellij.enable = true;
    zellij.settings = {
      pane_frames = false;
      # default_layout = "compact";
    };
  };
}
