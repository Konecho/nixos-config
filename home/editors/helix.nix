{pkgs, ...}: {
  programs.
    helix = {
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
    ];
  };
}
