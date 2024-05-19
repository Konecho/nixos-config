{pkgs, ...}: {
  programs.fish = {
    enable = true;
    functions.gitui = ''
      ssh-add ~/.ssh/id_ed25519 2> /dev/null
      ${pkgs.gitui}/bin/gitui
    '';
    loginShellInit = "";
    plugins = [
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
      {
        name = "foreign-env";
        inherit (pkgs.fishPlugins.foreign-env) src;
      }
      {
        name = "fish-ssh-agent";
        src = pkgs.fetchFromGitHub {
          owner = "danhper";
          repo = "fish-ssh-agent";
          rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
          sha256 = "sha256-e94Sd1GSUAxwLVVo5yR6msq0jZLOn2m+JZJ6mvwQdLs=";
        };
      }
    ];
  };
}
