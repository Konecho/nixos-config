{
  inputs,
  pkgs,
  ...
}: {
  # imports = [inputs.niri.nixosModules.niri];
  # programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
    niri
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = builtins.concatStringsSep " " [
          "tuigreet"
          ''--time --time-format="%F %T"''
          "--remember"
          "--cmd niri-session"
        ];
        user = "greeter";
      };
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };
}
