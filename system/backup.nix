{config, ...}: {
  services.borgbackup.jobs = let
    basicBorgJob = target: from: {
      encryption.mode = "none";
      paths = from;
      # environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i /home/danbst/.ssh/id_ed25519";
      # environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      # repo = "ssh://user@example.com//media/backup/${name}";
      # repo = "/backup/borg/${target}";
      repo = "/run/media/${config.mono.username}/546B-6466/borgbackup/${target}";
      removableDevice = true;
      compression = "zstd,1";
      startAt = "daily";
      persistentTimer = true;
      user = config.mono.username;
    };
  in {
    lanraragi = basicBorgJob "lanraragi" "/db/lanraragi";
    hydrus = basicBorgJob "hydrus" "/db/hydrus";
  };
}
