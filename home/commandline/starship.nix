{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings =
      (removeAttrs (builtins.fromTOML (
        builtins.readFile "${pkgs.starship}/share/starship/presets/plain-text-symbols.toml"
      )) ["os"])
      // {
        character = {
          error_symbol = "[x_x](bold red)";
          success_symbol = "[>_<](bold green)";
          vimcmd_symbol = "[0.0](bold green)";
        };
      }
      // {
        custom.jj = {
          shell = ["sh" "--norc" "--noprofile"];
          command = ''
            jj log --revisions @ --limit 1 --ignore-working-copy --no-graph --color always  --template '
              separate(" ",
                bookmarks.map(|x| truncate_end(10, x.name(), "…")).join(" "),
                tags.map(|x| truncate_end(10, x.name(), "…")).join(" "),
                raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
                raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                surround("\"", "\"", truncate_end(24, description.first_line(), "…")),
                  "(???)",
                ) ++ raw_escape_sequence("\x1b[0m"),
                if(conflict, "conflict"),
                if(divergent, "divergent"),
                if(hidden, "hidden"),
              )
            '
          '';
          when = "jj --ignore-working-copy root";
          symbol = "jj";
        };
        custom.jjstate = {
          shell = ["sh" "--norc" "--noprofile"];
          when = "jj --ignore-working-copy root";
          command = ''
            jj log -r@ -n1 --ignore-working-copy --no-graph -T "" --stat | tail -n1 | sd "(\d+) files? changed, (\d+) insertions?\(\+\), (\d+) deletions?\(-\)" ' ''${1}m ''${2}+ ''${3}-' | sd " 0." ""
          '';
        };
        git_status.disabled = true;
        custom.git_status = {
          when = "! jj --ignore-working-copy root";
          command = "starship module git_status";
          style = "";
        };
        git_commit.disabled = true;
        custom.git_commit = {
          when = "! jj --ignore-working-copy root";
          command = "starship module git_commit";
          style = "";
        };
        git_metrics.disabled = true;
        custom.git_metrics = {
          when = "! jj --ignore-working-copy root";
          command = "starship module git_metrics";
          style = "";
        };
        git_branch.disabled = true;
        custom.git_branch = {
          when = "! jj --ignore-working-copy root";
          command = "starship module git_branch";
          style = "";
        };
      };
  };

  home.packages = with pkgs; [
    sd
  ];
}
