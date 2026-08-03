{pkgs, ...}: {
  programs.helix.extraPackages = with pkgs; [
    uiua
  ];
  programs.helix.languages = let
    mainProgram = "uiua";
  in {
    language = with pkgs; [
      {
        name = mainProgram;
        scope = "source.uiua";
        file-types = ["ua"];
        language-servers = ["uiua-lsp"];
        formatter = {
          command = mainProgram;
          args = ["fmt" "--io"];
        };
        indent = {
          tab-width = 2;
          unit = "  ";
        };
        auto-format = true;
        injection-regex = "uiua";
        roots = [];
        comment-token = "#";
        shebangs = ["uiua"];
        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = "\"";
        };
      }
    ];
    language-server = with pkgs; {
      uiua-lsp = {
        command = mainProgram;
        args = ["lsp"];
      };
    };
    # hx -g fetch
    # hx -g build
    grammer = [
      {
        name = "uiua";
        git = "https://github.com/shnarazk/tree-sitter-uiua";
        rev = "0da15357bc1179b187018131dc20c2395e77ce71";
      }
    ];
  };
}
