let
  wsl-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6JF1QVNQH+DwPENPTDyi+XUJilipmU6dea1i8chd2d";
  deskmini-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6z6TbfoDoVnjsUDgdYSLVQO15mWkFxsPc3i5Yw738H";
  users = [wsl-user deskmini-user];

  wsl-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsWQUYB/KhKLag6J0C3hDwdNGOpqelzQ/gXt8jAG9pE";
  deskmini-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9+kvgMDcvBUGkR+tcUCdkwmTsawgGqQEUSv6SNpZFN root@deskmini";
  systems = [wsl-host deskmini-host];

  all-secrets = users ++ systems;
in {
  "openrouter.age".publicKeys = all-secrets;
  # pi agent auth (auth.json), decrypted to ~/.pi/agent/auth.json
  "pi-auth.age" = {
    publicKeys = all-secrets;
    path = "/home/.pi/agent/auth.json";
    owner = "mei";
    group = "users";
    mode = "0600";
  };
}
