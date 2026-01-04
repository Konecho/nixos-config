let
  wsl-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6JF1QVNQH+DwPENPTDyi+XUJilipmU6dea1i8chd2d";
  users = [wsl-user];

  wsl-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsWQUYB/KhKLag6J0C3hDwdNGOpqelzQ/gXt8jAG9pE";
  systems = [wsl-host];
in {
  # "openrouter.age".publicKeys = [wsl-user wsl-host];
}
