{pkgs, ...}: {
  home.shellAliases = {
    man = "batman";
  };
  programs = {
    bash = {
      enable = true;
      # profileExtra = "";
      historyIgnore = ["l" "ls" "z" "cd" "exit"];
    };
    fish = {
      enable = true;
      functions = {
        fish_greeting = ''
          pwd | ${pkgs.pokemonsay}/bin/pokemonsay -N
        '';
        nixlf = ''
          set derv $(nix show-derivation $argv|jq -rs '.[0]|to_entries[].value.outputs.out.path')
          if [ -d $derv ]
            lf $derv
          else
            echo $(nix show-derivation $argv|jq -s '.[0]|to_entries[].value.outputs')
          end
        '';
        gitui = ''
          git config user.name "$(python ~/scripts/random_pokemon_name.py)"
          ssh-add ~/.ssh/id_ed25519 2> /dev/null
          ${pkgs.gitui}/bin/gitui
        '';
      };
      loginShellInit = ''
        # Fish syntax highlighting
        set -g fish_color_autosuggestion '555'  'brblack'
        set -g fish_color_cancel -r
        set -g fish_color_command --bold
        set -g fish_color_comment red
        set -g fish_color_cwd green
        set -g fish_color_cwd_root red
        set -g fish_color_end brmagenta
        set -g fish_color_error brred
        set -g fish_color_escape 'bryellow'  '--bold'
        set -g fish_color_history_current --bold
        set -g fish_color_host normal
        set -g fish_color_match --background=brblue
        set -g fish_color_normal normal
        set -g fish_color_operator bryellow
        set -g fish_color_param cyan
        set -g fish_color_quote yellow
        set -g fish_color_redirection brblue
        set -g fish_color_search_match 'bryellow'  '--background=brblack'
        set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
        set -g fish_color_user brgreen
        set -g fish_color_valid_path --underline
      '';
      plugins = [
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
    starship.enable = true;
  };
}
