{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
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
          when = "jj-starship detect";
          shell = ["jj-starship"];
          format = "$output ";
        };
        git_status.disabled = true;
        git_branch.disabled = true;
      };
  };
}
