{
  pkgs,
  config,
  lib,
  ...
}: let
  tabbarColors = "";
  # lib.strings.optionalString
  # (builtins.hasAttr "stylix" config.lib) (let
  #   base16 = config.lib.stylix.colors;
  # in ''
  #   colors = {
  #     tab_bar = {
  #       background = '#${base16.base01}',
  #       active_tab = {
  #         bg_color = '#${base16.base02}',
  #         fg_color = '#${base16.base07}',
  #       },
  #       inactive_tab = {
  #         bg_color = '#${base16.base03}',
  #         fg_color = '#${base16.base07}',
  #       },
  #       new_tab = {
  #         bg_color = '#${base16.base01}',
  #         fg_color = '#${base16.base07}',
  #       },
  #       inactive_tab_hover = {
  #         bg_color = '#${base16.base05}',
  #         fg_color = '#${base16.base02}',
  #       },
  #       new_tab_hover = {
  #         bg_color = '#${base16.base05}',
  #         fg_color = '#${base16.base02}',
  #       },
  #     },
  #   },
  # '');
in {
  programs = {
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
