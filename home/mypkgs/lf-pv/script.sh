#!/bin/sh
case "$1" in
*.tar*) tar tf "$1" ;;
*.zip) unzip -l "$1" ;;
*.rar) unrar l "$1" ;;
*.7z) 7z l "$1" ;;
*.pdf) pdftotext "$1" - ;;
*.mp3 | *.avi | *.mp4 | *.webm | *.mkv | *.flv | *.mov | *.mpg | *.wmv | *.ogg) mediainfo "$1" ;;
# *.jpg|*.png) timg -g30x30 "$1";;
# *.jpg|*.png) chafa -c 256 "$1";;
*.bmp | *.jpg | *.jpeg | *.png | *.xpm | *.webp | *.gif)
    chafa "$1" -f sixel | sed 's/#/\n#/g'
    ;;
*) highlight -O ansi "$1" || cat "$1" ;;
esac
