{pkgs, ...}: {
  home.packages = with pkgs; [
    # [shell utils]
    logtop # count line
    wf-recorder
    zscroll
    libnotify # <notify-send>
    # rename files in editor
    vimv-rs # <vimv *.mp3>
    # renameutils # imv deurlname icp icmd qmv qcmd qcp
    entr
    gdu

    # [document]
    poppler_utils # <pdftotext>
    highlight
    unoconv # doc to docx
    catdoc

    # [image]
    timg
    ueberzug
    ueberzugpp

    # [media]
    mediainfo
    exiftool
    transmission

    # [network]
    httpie
    nmap
    qrcp
    socat # <echo 'cycle pause' | socat - /tmp/mpv-socket>

    # [tui]
    sc-im # 表格
    mc # 文件管理
  ];
}
