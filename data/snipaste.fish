#!/usr/bin/env fish
set MAX_CHARS 80
set PIXELS_PER_CHAR 12
set WIN_CLASS snipaste-popup

set mime (wl-paste --list-types)

if string match -q "image/*" "$mime"
    wl-paste | swayimg --class=$WIN_CLASS -
    return
end

set text (wl-paste | string collect)
if test -z "$text"
    return
end

set actual_max_line (echo "$text" | wc -L)

if test $actual_max_line -gt $MAX_CHARS
    set render_width (math $MAX_CHARS "*" $PIXELS_PER_CHAR)
    set size_param -size "$render_width"x
else
    set size_param
end

printf "%s" "$text" | magick $size_param pango:@- png:- | swayimg -a $WIN_CLASS -
