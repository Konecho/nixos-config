{
  pkgs,
  lib,
  config,
  ...
}: let
  base16 = config.lib.stylix.colors;
in {
  home.packages = [
    (
      pkgs.writeShellScriptBin "stylix-sandbar" ''
        #!/bin/sh
        FIFO="$XDG_RUNTIME_DIR/sandbar"
        [ -e "$FIFO" ] && rm -f "$FIFO"
        mkfifo "$FIFO"

        while cat "$FIFO"; do :; done | sandbar \
        	-font "${config.stylix.fonts.serif.name}" \
        	-active-fg-color "#${base16.base05}" \
        	-active-bg-color "#${base16.base02}" \
        	-inactive-fg-color "#${base16.base05}" \
        	-inactive-bg-color "#${base16.base00}" \
        	-urgent-fg-color "#${base16.base08}" \
        	-urgent-bg-color "#${base16.base0F}" \
        	-title-fg-color "#${base16.base05}" \
        	-title-bg-color "#${base16.base00}"
      ''
    )
    (
      pkgs.writeShellScriptBin "stylix-river" ''
        #!/bin/sh
        riverctl background-color 0x${base16.base00}
        riverctl border-color-focused 0x${base16.base0A}
        riverctl border-color-unfocused 0x${base16.base03}
      ''
    )
    (
      pkgs.writeShellScriptBin "stylix-bg" ''
        #!/bin/sh
        ${pkgs.wbg}/bin/wbg ${config.stylix.image}
      ''
    )
    (
      pkgs.writeShellScriptBin "stylix-nwg" ''
        #!/bin/sh
        ${pkgs.nwg-wrapper}/bin/nwg-wrapper -s /etc/nixos/data/nwg-widget.py -r 60000 -p right -mr 200
      ''
    )
    pkgs.ansifilter
    (
      pkgs.writeShellScriptBin "stylix" ''
        #!/bin/sh
        stylix-river
        stylix-bg &
        stylix-sandbar
      ''
    )
  ];
}
