{
  inputs,
  pkgs,
  ...
}: {
  imports = [];
  environment.systemPackages = [
    # inputs.ghostty.packages.x86_64-linux.default
  ];
  nix.settings = {
    extra-substituters = ["https://ghostty.cachix.org"];
    extra-trusted-public-keys = ["ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="];
  };
}
