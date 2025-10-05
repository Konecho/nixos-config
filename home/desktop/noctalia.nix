{
  pkgs,
  inputs,
  config,
  ...
}: let
  noctaliaPkgs =
    inputs.noctalia.packages.${config.nixpkgs.system}.default;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];
  home.packages = with pkgs; [
    noctaliaPkgs
    jq
    colordiff
    (
      writeShellScriptBin "noctalia-diff" ''
        diff -u <(jq -S . ~/.config/noctalia/settings.json) <(jq -S . ~/.config/noctalia/gui-settings.json) | colordiff
      ''
    )
  ];
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "comfortable";
        floating = true;
      };
      colorSchemes.darkMode = false;
      wallpaper.directory = "/home/media/photos/wallpapers";
      general = {
      };
    };
  };
  systemd.user.services = {
    "noctalia-shell" = {
      Unit = {
        Description = "Noctalia Shell - Wayland desktop shell";
        After = [config.wayland.systemd.target];
        PartOf = [config.wayland.systemd.target];
        StartLimitIntervalSec = 60;
        StartLimitBurst = 3;
      };
      Service = {
        Type = "exec";
        ExecStart = "${noctaliaPkgs}/bin/noctalia-shell";
        Restart = "on-failure";
        RestartSec = 3;
        TimeoutStartSec = 10;
        TimeoutStopSec = 5;
        Environment = [
          "QT_QPA_PLATFORM=wayland"
          "ELECTRON_OZONE_PLATFORM_HINT=auto"
          "NOCTALIA_SETTINGS_FALLBACK=%h/.config/noctalia/gui-settings.json"
        ];
        Slice = "session.slice";
      };
      Install = {
        WantedBy = [config.wayland.systemd.target];
      };
    };
  };

  services.cliphist.enable = true;
  programs = {
    niri = {
      settings = let
        noctalia = cmd: ["noctalia-shell" "ipc" "call"] ++ (pkgs.lib.splitString " " cmd);
      in {
        # spawn-at-startup = [{command = ["noctalia-shell"];}];
        binds = with config.lib.niri.actions; {
          "Mod+Shift+L".action.spawn = noctalia "lockScreen toggle";
          "Mod+Space".action.spawn = noctalia "launcher toggle";
          "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
          "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
          "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
        };
      };
    };
  };
}
