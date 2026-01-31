{config, ...}: {
  ## the first backup, run
  # borgmatic repo-create --encryption=none
  ## to backup, run
  # borgmatic create --verbosity 1 --list --stats
  programs.borgmatic = {
    enable = true;
    backups = let
      mnt = "/run/media/${config.mono.username}/546B-6466";
      mkBackup = name: p: {
        location = {
          sourceDirectories = [p];
          repositories = ["${mnt}/borgbackup/${name}"];
          # excludeHomeManagerSymlinks = true;
        };
        hooks.extraConfig.commands = [
          {
            before = "repository";
            run = ["findmnt ${mnt} > /dev/null || exit 75"];
          }
        ];
        retention = {
          keepDaily = 7;
          keepWeekly = 4;
          keepMonthly = 6;
        };
      };
    in {
      logseq = mkBackup "logseq" "/home/logseq";
      photos = mkBackup "photos" "/home/media/photos";
      pictures = mkBackup "pictures" "/db/Pictures";
      cwm-novel = mkBackup "cwm-novel" "/db/HedgehogCatAppNovelDownload";
      pixiv-novel = mkBackup "pixiv-novel" "/db/pixiv-novel";
    };
  };
}
