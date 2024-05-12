{pkgs, ...}: {
  home.packages = with pkgs; [
    # [shell utils]
    logtop # count line
    wf-recorder
    zscroll
    libnotify # <notify-send>
    killall
    # rename files in editor
    vimv-rs # <vimv *.mp3>
    # renameutils # imv deurlname icp icmd qmv qcmd qcp

    # [archive]
    unrar
    unzip
    p7zip # <7z>

    # [document]
    poppler_utils # <pdftotext>
    highlight
    unoconv # doc to docx

    # [image]
    chafa
    timg
    imagemagick
    ueberzug
    ueberzugpp

    # [media]
    mediainfo
    ffmpeg
    yt-dlp
  ];
}
