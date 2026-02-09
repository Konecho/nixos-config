{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [./commandline/pkm-shell.nix];
  home.packages = with pkgs;
    [
      clash-verge-rev
      nemo
      # clash-nyanpasu

      # czkawka # duplicates

      # hyper

      qt6.qtwayland
      # hydrus
      ## sometime need an middle version for conversion
      # (hydrus.overrideAttrs (f: p: rec {
      #   version = "558";
      #   src = fetchFromGitHub {
      #     owner = "hydrusnetwork";
      #     repo = "hydrus";
      #     rev = "refs/tags/v${version}";
      #     hash = "sha256-qVoA8IZYLUJ6Li/M8ORjkfntc06oMVD7739F79sFLjM=";
      #   };
      # }))
    ]
    ++ (
      with inputs.winapps.packages.${system}; [winapps winapps-launcher]
    );
  programs = {
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
    zathura.enable = true; # pdf viewer
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-ceintl.vscode-language-pack-zh-hans
        ms-python.python
        jnoortheen.nix-ide
        # continue.continue
        mhutchie.git-graph
        mkhl.direnv
        # visualjj.visualjj
        ndonfris.fish-lsp
        rust-lang.rust-analyzer
        nefrob.vscode-just-syntax
      ];
    };
    # pidgin = {
    #   enable = true;
    #   plugins = with pkgs; [purple-matrix purple-discord];
    # };
  };
}
