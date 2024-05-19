{
  pkgs,
  config,
  ...
}: {
  programs.pistol.enable = true;
  programs.pistol.associations = with pkgs; [
    {
      mime = "image/*";
      command = "${exiftool}/bin/exiftool %pistol-filename% && ${chafa}/bin/chafa -f symbols %pistol-filename%";
    }
    {
      mime = "video/*";
      command = "${mediainfo}/bin/mediainfo %pistol-filename%";
    }
    {
      mime = "audio/*";
      command = "${mediainfo}/bin/mediainfo %pistol-filename%";
    }
    {
      mime = "application/json";
      command = "sh: ${jq}/bin/jq '.' %pistol-filename%";
    }
    {
      mime = "application/zip";
      command = "sh: ${unzip}/bin/unzip -l %pistol-filename%";
    }
    {
      mime = "application/pdf";
      command = "sh: ${poppler_utils}/bin/pdftotext -l 10 -nopgbrk -q -- %pistol-filename% - | fmt -w %pistol-extra0%";
    }
    {
      fpath = ".*.torrent$";
      command = "${transmission}/bin/transmission-show %pistol-filename%";
    }
    {
      fpath = ".*.doc$";
      command = "${catdoc}/bin/catdoc %pistol-filename%";
    }
    {
      fpath = ".*.xls$";
      command = "${catdoc}/bin/xls2csv %pistol-filename%";
    }
    {
      mime = "text/*";
      command = "sh: ${bat}/bin/bat --paging=never --color=always --terminal-width=%pistol-extra0% %pistol-filename%";
    }
    {
      mime = "application/*";
      command = "${hexyl}/bin/hexyl -n 1kb %pistol-filename%";
    }
  ];
}
