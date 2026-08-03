{
  description = "mono — enforce a single-user NixOS + home-manager setup";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    home-manager,
    ...
  }: {
    nixosModules = {
      mono = ./nixos.nix;
      # NixOS + home-manager 集成：自动接入 home-manager 模块、强制 user-hm.* alias、
      # 并把 mono.homeModules 接线到 home-manager.users.<username>.imports
      withHome = import ./withHome.nix {inherit home-manager;};
      default = self.nixosModules.mono;
    };
    homeModules = {
      mono = ./home.nix;
      default = self.homeModules.mono;
    };
  };
}
