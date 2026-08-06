{
  config,
  lib,
  flake,
  ...
}: {
  imports = [
    ../../disko-raid.nix
  ];
  # https://github.com/NixOS/nixpkgs/issues/72394#issuecomment-549110501
  environment.etc."mdadm.conf".text = ''
    MAILADDR root
  '';
  services.borgbackup.jobs = let
    basicBorgJob = target: {
      encryption.mode = "none";
      # environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i /home/danbst/.ssh/id_ed25519";
      # environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      # repo = "ssh://user@example.com//media/backup/${name}";
      repo = "/backup/borg/${target}";
      # repo = "/run/media/${config.username}/546B-6466/borgbackup/${target}";
      # removableDevice = true;
      compression = "zstd,1";
      startAt = "daily";
      persistentTimer = true;
      user = config.username;
    };
    fromFile = path: let
      # 读取文件内容（去首尾空格、过滤空行）
      content = builtins.readFile path;
      lines = lib.splitString "\n" content;
      processed = builtins.filter (line: line != "") (map lib.trim lines);
    in
      processed;
  in {
    lanraragi =
      basicBorgJob "lanraragi"
      // rec {
        paths = "/db/lanraragi";
        exclude = map (x: paths + "/" + x) [
          "**/.direnv"
        ];
      };
    hydrus =
      basicBorgJob "hydrus"
      // {
        paths = "/db/hydrus";
      };
    home =
      basicBorgJob "home"
      // (let
        home = config.users.users.${config.username}.home;
      in {
        paths = map (x: home + "/" + x) ([
            "acgn/comic"
            "acgn/novel"
            "media"
            "system"
            "documents"
          ]
          ++ (fromFile ../../data/home-backup.list));
        exclude = map (x: home + "/" + x) [
          "**/target/*"
          "**/.direnv"
          "**/.venv"
          "**/*.iso"
        ];
      });
  };
}
