{pkgs, ...}: {
  home.sessionVariables.TERMINAL = "wezterm";
  programs = {
    wezterm = {
      enable = true;
      extraConfig = ''
        return {
          enable_tab_bar = true,
          use_fancy_tab_bar = false,
          -- hide_tab_bar_if_only_one_tab = true,

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
          font_size = 12.0
        }
      '';
    };
    alacritty = {
      enable = true;
      settings = {
        opacity = 0.8;
        font.normal.family = "Maple Mono SC NF";
        font.size = 12;
      };
    };
  };
}
