{pkgs, ...}: {
  imports = [
    ./niri.nix
    ./river.nix
    # ./cosmic.nix
  ];
  environment.systemPackages = with pkgs; [
    (greetd.tuigreet.overrideAttrs (f: p: {
      # postPatch = ''
      #   mkdir -p contrib/locales/zh-CN
      #   ln -s ${./tuigreet.zh-CN.ftl} contrib/locales/zh-CN/tuigreet.ftl
      # '';
    }))
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = builtins.concatStringsSep " " [
          "tuigreet"
          "--user-menu"
          "--user-menu-min-uid 1000"
          "--user-menu-max-uid 1001"
          "--time"
          # ''--time-format="%x, %A, %H:%M"''
          ''--time-format="%H:%M"''
          "--asterisks"
          "--power-shutdown 'shutdown -h now'"
          "--cmd"
          "niri-session"
          # "river"
        ];
      };
    };
  };
}
