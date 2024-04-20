{
  pkgs,
  rootPath,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
    grim
    slurp
    kickoff
    rofi
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
        	alacritty --class="alacritty"
          riverctl rule-add -app-id "alacritty" position
          riverctl rule-add -app-id "alacritty" dimensions
        }
      ''
    )
    (
      writeShellScriptBin "select-clipboard" ''
        #!/bin/sh
        rofi -modi clipboard:${writeScript "data/cliphist-rofi-img.sh" (builtins.readFile (rootPath + /data/cliphist-rofi-img.sh))} -show clipboard -show-icons
      ''
    )
  ];
  services.cliphist.enable = true;
}
