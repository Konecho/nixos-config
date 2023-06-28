{pkgs, ...}: {
  home.sessionVariables.EDITOR = "hx";
  programs.helix = {
    enable = true;
    languages.language = [
      {
        name = "nix";
        formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
        auto-format = true;
      }
      {
        name = "bash";
        formatter = {command = "${pkgs.shfmt}/bin/shfmt";};
        auto-format = true;
      }
      {
        name = "toml";
        formatter = {command = "${pkgs.taplo}/bin/taplo fmt -";};
        auto-format = true;
      }
    ];
  };
}
