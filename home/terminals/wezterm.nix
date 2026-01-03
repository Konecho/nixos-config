{lib, ...}: let
  weztermConfig = {
    enable_tab_bar = false;
    front_end = "WebGpu";
    window_close_confirmation = "NeverPrompt";
  };
in {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = ${lib.generators.toLua {} weztermConfig}
      return config
    '';
  };
}
