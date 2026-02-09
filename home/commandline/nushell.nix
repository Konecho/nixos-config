{
  config,
  pkgs,
  ...
}: {
  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
    };
    # shellAliases =
    #   config.home.shellAliases
    #   ++ (with pkgs; {
    #     ls = "${lsd}/bin/lsd";
    #     ll = "${lsd}/bin/lsd -l";
    #     la = "${lsd}/bin/lsd -A";
    #     lt = "${lsd}/bin/lsd --tree";
    #     lla = "${lsd}/bin/lsd -lA";
    #     llt = "${lsd}/bin/lsd -l --tree";
    #   });
  };
}
