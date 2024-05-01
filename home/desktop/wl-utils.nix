{
  pkgs,
  rootPath,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
    grim
    slurp
    rofi
    alacritty
    wezterm
    chafa
    (
      writeShellScriptBin "screenshot-to-clipboard" ''
        #!/bin/sh
        grim -g "$(slurp)" - | wl-copy --type image/png
      ''
    )
    (
      writeShellScriptBin "draw-terminal" ''
        #!/bin/sh
        set -e
        slurp | {
        	IFS=', x' read -r x y w h
        	riverctl rule-add -app-id "alacritty" float
        	riverctl rule-add -app-id "alacritty" position $x $y
        	riverctl rule-add -app-id "alacritty" dimensions $w $h
        	alacritty --class="alacritty" &
          riverctl rule-add -app-id "alacritty" position
          riverctl rule-add -app-id "alacritty" dimensions
        }
      ''
    )
    # (
    #   writeShellScriptBin "select-clipboard" ''
    #     #!/bin/sh
    #     rofi -modi clipboard:${writeScript "cliphist-rofi-img" (builtins.readFile (rootPath + /data/cliphist-rofi-img))} -show clipboard -show-icons
    #   ''
    # )
    (
      writeShellScriptBin "select-clipboard" ''
        #!/bin/sh
        riverctl rule-add -app-id "clipboard-float" float
        wezterm start --class clipboard-float -e bash ${writeScript "cliphist-fzf-sixel" (builtins.readFile (rootPath + /data/cliphist-fzf-sixel))} &
      ''
    )
    (
      writeShellScriptBin "app-launcher" ''
        #!/bin/sh
        riverctl rule-add -app-id "term-float" float
        wezterm start --class term-float -e bash ${writeScript "fzfmenu" (builtins.readFile (rootPath + /data/fzfmenu))} &
      ''
    )
    (
      writeShellScriptBin "sandbar-status" (builtins.readFile (rootPath + /data/sandbar/status))
    )
    (
      writeShellScriptBin "sandbar-bar" (builtins.readFile (rootPath + /data/sandbar/bar))
    )
  ];
  services.cliphist.enable = true;
}
