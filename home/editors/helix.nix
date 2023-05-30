{pkgs, ...}: {
  home.sessionVariables.EDITOR = "hx";
  programs.
    helix = {
    enable = true;
    languages.language = [
      {
        name = "nix";
        formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
        auto-format = true;
      }
    ];
  };
}
