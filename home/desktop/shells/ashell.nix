{pkgs, ...}: {
  programs.ashell = {
    enable = true;
    settings = {
    };
    systemd.enable = true;
  };
}
