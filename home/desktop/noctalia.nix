{
  pkgs,
  inputs,
  config,
  ...
}: let
  noctalia = cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];
  home.packages = [
    inputs.noctalia.packages.${config.nixpkgs.system}.default
  ];
  programs.noctalia-shell = {
    enable = true;
    # settings = {
    #   # configure noctalia here; defaults will
    #   # be deep merged with these attributes.
    #   bar = {
    #     density = "compact";
    #     position = "right";
    #     showCapsule = false;
    #     widgets = {
    #       left = [
    #         {
    #           id = "SidePanelToggle";
    #           useDistroLogo = true;
    #         }
    #         {
    #           id = "WiFi";
    #         }
    #         {
    #           id = "Bluetooth";
    #         }
    #       ];
    #       center = [
    #         {
    #           hideUnoccupied = false;
    #           id = "Workspace";
    #           labelMode = "none";
    #         }
    #       ];
    #       right = [
    #         {
    #           alwaysShowPercentage = false;
    #           id = "Battery";
    #           warningThreshold = 30;
    #         }
    #         {
    #           formatHorizontal = "HH:mm";
    #           formatVertical = "HH mm";
    #           id = "Clock";
    #           useMonospacedFont = true;
    #           usePrimaryColor = true;
    #         }
    #       ];
    #     };
    #   };
    #   # colorSchemes.predefinedScheme = "Monochrome";
    #   general = {
    #     # avatarImage = "/home/drfoobar/.face";
    #     # radiusRatio = 0.2;
    #   };
    #   location = {
    #     monthBeforeDay = true;
    #     name = "Marseille, France";
    #   };
    # };
  };
  programs = {
    niri = {
      # ...
      settings = {
        binds = with config.lib.niri.actions; {
          # ...
          "Mod+Shift+L".action.spawn = noctalia "lockScreen toggle";
          "Mod+Space".action.spawn = noctalia "launcher toggle";
          "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
          "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
          "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
          # etc
        };
      };
    };
  };
}
