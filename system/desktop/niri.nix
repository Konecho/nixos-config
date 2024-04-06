{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.niri.nixosModules.niri];
  programs.niri.enable = true;
  environment.systemPackages = [
    pkgs.greetd.tuigreet
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
}
