{pkgs, ...}: {
  programs.river = {
    enable = true;
    extraPackages = with pkgs; [
    ];
  };
}
