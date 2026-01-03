{
  pkgs,
  config,
  lib,
  ...
}: {
  programs = {
    home-manager.enable = true;
    starship = {
      enable = true;
      enableTransience = true;
      settings =
        (removeAttrs (builtins.fromTOML (
          builtins.readFile "${pkgs.starship}/share/starship/presets/plain-text-symbols.toml"
        )) ["os"])
        // {
          character = {
            error_symbol = "[x_x](bold red)";
            success_symbol = "[>_<](bold green)";
            vimcmd_symbol = "[0.0](bold green)";
          };
        };
    };
    # thefuck.enable = true;
    # rofi.enable = true;
    navi.enable = true;
    noti.enable = true; # <do-something>;noti> or <noti do-something>
    aria2.enable = true;
    atuin.enable = true; # <ctrl+r>
    atuin.enableFishIntegration = false;
    fish.interactiveShellInit = ''
      ${lib.getExe pkgs.atuin} init fish | sed 's/-k up/up/' | source
    '';
    broot.enable = true; # <br> tree-view search
    carapace.enable = true;

    ## <tldr>
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };
  };
  home.packages = with pkgs; [
    wget
    file
    xdg-utils # <xdg-open>
    sysz
    usbutils # <lsusb>

    # calc
    jq
    (python3.withPackages (py: with py; [requests ptpython]))
    devenv
  ];
}
