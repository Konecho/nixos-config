{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  gtk.font = {
    package = pkgs.maple-mono-SC-NF;
    name = "Maple Mono SC NF";
  };
  home.packages = with pkgs; [
    monocraft
    nur.repos.vanilla.Win10_LTSC_2021_fonts
    # nur.repos.vanilla.apple-fonts.NY
    mypkgs.scutthesis.fonts.windows
  ];
}
