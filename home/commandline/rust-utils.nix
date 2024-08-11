{pkgs, ...}: {
  home.shellAliases = {
    man = "batman";
    cat = "bat";
    top = "btm";
    lf = "yazi";
    tmux = "zellij";
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
    du-dust
    ripgrep
    procs
    sd
    trashy
  ];
  programs = {
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
    zoxide.enable = true;
    bottom.enable = true;
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
    zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        default_layout = "compact";
      };
    };
    # ranger/lf/joshuto replacement
    yazi = {
      enable = true;
    };
  };
}
