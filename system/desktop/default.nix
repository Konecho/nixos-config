{pkgs, ...}: {
  imports = [
    # ./gnome.nix
    # ./kde.nix
    # ./ags.nix
    # ./niri.nix
    ./river.nix
  ];
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = builtins.concatStringsSep " " [
          "tuigreet"
          "--remember"
          ''--time --time-format="%F %T"''
          "--asterisks "
          "--power-shutdown 'shutdown -h now'"
          # "--cmd niri-session"
          "--cmd river"
        ];
      };
    };
  };
}
