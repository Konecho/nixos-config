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
      extraConfig = ''
        return {
          enable_tab_bar = true,
          use_fancy_tab_bar = false,
          hide_tab_bar_if_only_one_tab = true,

          -- window_background_opacity = 0.8,
          -- color_scheme = 'Solarized Dark Higher Contrast (Gogh)',
          window_decorations = NONE,
          enable_scroll_bar = true,
          window_padding = {
            left = 0,
            right = "1cell",
            top = 0,
            bottom = 0,
          },

          font = wezterm.font("Maple Mono SC NF"),
          harfbuzz_features = {"ss01","ss02","ss03"},
          font_size = 12.0,
          ${tabbarColors}
        }
      '';
    };
  };
}
