{pkgs, ...}: {
  imports = [
    ./niri.nix
    # ./cosmic.nix
    ./stylix.nix
  ];
  programs.regreet.enable = true;
  # services.greetd.settings.default_session.command = lib.mkDefault "${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.fish}/bin/fish";
  services.greetd = {
    enable = true;
  };
}
