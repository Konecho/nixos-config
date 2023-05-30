{pkgs, ...}: {
  programs = {
    eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./.eww;
    };
  };
  home.packages = with pkgs; [
    # mypkgs.shox
    mypkgs.baru
  ];
}
