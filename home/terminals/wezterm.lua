local wezterm = require 'wezterm'
local act = wezterm.action;
return {
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,

  front_end = "WebGpu",
  -- enable_wayland = false,

  -- window_background_opacity = 0.8,
  -- color_scheme = 'cyberpunk',
  window_decorations = NONE,
  -- window_decorations = "RESIZE",
  enable_scroll_bar = true,
  window_padding = {
    left = 0,
    right = "1cell",
    top = 0,
    bottom = 0,
  },

  font = wezterm.font("Maple Mono NF CN"),
  harfbuzz_features = { "ss01", "ss02", "ss03" },
  font_size = 12.0,

  mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },

    -- and make CTRL-Click open hyperlinks
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = act.OpenLinkAtMouseCursor,
    },

    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.Nop,
    }
  },
}
