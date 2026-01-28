{config, ...}: {
  services.borgbackup.jobs = let
    common-excludes = [
      # Largest cache dirs
      ".cache"
      "*/cache2" # firefox
      "*/Cache"
      ".config/Slack/logs"
      ".config/Code/CachedData"
      ".container-diff"
      ".npm/_cacache"
      # Work related dirs
      "*/node_modules"
      "*/bower_components"
      "*/_build"
      "*/.tox"
      "*/venv"
      "*/.venv"
    ];
    basicBorgJob = target: from: {
      encryption.mode = "none";
      paths = from;
      # environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i /home/danbst/.ssh/id_ed25519";
      # environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      # repo = "ssh://user@example.com//media/backup/${name}";
      repo = "/backup/borg/${target}";
      compression = "zstd,1";
      startAt = "daily";
      persistentTimer = true;
      user = config.mono.username;
    };
  in {
    logseq = basicBorgJob "logseq" "/home/logseq";
    photos = basicBorgJob "photos" "/home/media/photos";
    lanraragi = basicBorgJob "lanraragi" "/db/lanraragi";
    hydrus = basicBorgJob "hydrus" "/db/hydrus";
    pixiv-novel = basicBorgJob "pixiv-novel" "/db/pixiv-novel";
    cwm-novel =
      basicBorgJob "cwm-novel" "/db/HedgehogCatAppNovelDownload"
      // {
        startAt = "daily";
      };
    pictures =
      basicBorgJob "pictures" "/db/Pictures"
      // {
        startAt = "daily";
      };
    # extra-drive-important =
    #   basicBorgJob "backups/station/extra-drive-important"
    #   // rec {
    #     paths = "/media/extra-drive/important";
    #     exclude = map (x: paths + "/" + x) common-excludes;
    #   };
  };
  # services.duplicati = {
  #   enable = true;
  #   dataDir = "/db/duplicati";
  #   parameters = ''
  #     --webservice-password=5112
  #   '';
  # };
}
