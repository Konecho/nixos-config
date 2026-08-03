{
  description = "A flake";
  inputs = {
    # not follow
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    preservation.url = "github:nix-community/preservation";
    my-nixpkgs.url = "github:Konecho/my-nixpkgs";
    # nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # follow nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 上游 main 已修复 home-manager 选项搜索（options.xhtml 改版为 print.html），
    # 但未发 release，nixpkgs 仍是 2.4.3。overlay 临时指向上游 main，
    # nixpkgs 更新到修复版后可删除 input + overlay。
    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    # 本地模块（mono/ 目录自包含，可整体发布为独立 flake）
    mono = {
      url = "path:./modules/mono";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.nur.follows = "";
    # };
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # niri-nix = {
    #   url = "git+https://codeberg.org/BANanaD3V/niri-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # niri = {
    #   url = "github:niri-wm/niri";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # minegrub-theme = {
    #   url = "github:Lxtharia/minegrub-theme";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # minegrub-world-sel-theme = {
    #   url = "github:Lxtharia/minegrub-world-sel-theme";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # minecraft-plymouth-theme = {
    #   url = "github:nikp123/minecraft-plymouth-theme";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # minesddm = {
    #   url = "github:Davi-S/sddm-theme-minesddm";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # winapps = {
    #   url = "github:winapps-org/winapps";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # quickshell = {
    #   url = "github:quickshell-mirror/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # dank = {
    #   url = "github:AvengeMedia/DankMaterialShell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # noctalia = {
    #   url = "github:noctalia-dev/noctalia";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # caelestia = {
    #   url = "github:jutraim/niri-caelestia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.quickshell.follows = "quickshell";
    # };
    # ambxst = {
    #   url = "github:Axenide/Ambxst";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hexecute = {
    #   url = "github:ThatOtherAndrew/Hexecute";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     home-manager.follows = "home-manager";
    #   };
    # };
    # not flake
    # pokesprite = {
    #   url = "github:msikma/pokesprite";
    #   flake = false;
    # };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    lib = import ./lib.nix inputs;
    # mcp-nixos 2.4.3 抓的 options.xhtml 已被 home-manager 文档改版为 JS 重定向页，
    # 导致 home-manager 选项搜索失效；上游 #192 修复后仍在 main 分支（未发 release）。
    # 用上游官方 lib.mkMcpNixos 从 main 构建，不用 overlays.default：后者会附带
    # fastmcp3 overlay 把 fastmcp 锁到 3.2.4（本机 nixpkgs 已是 3.3.1，无需降级）。
    mcpNixosOverlay = final: prev: {
      mcp-nixos = inputs.mcp-nixos.lib.mkMcpNixos {pkgs = final;};
    };
    pkgs = lib.mkPkgs {
      inherit system;
      overlays = [mcpNixosOverlay];
    };
    scanPath = lib.scanPath;
  in {
    homeConfigurations = lib.mkUsr {
      inherit pkgs;
      modules = scanPath {
        _path = ./home;
        excludeFiles = ["guix.nix"];
      };
    };

    nixosConfigurations = {
      deskmini = lib.mkSys {
        hostname = "deskmini";
        inherit pkgs;
        modules =
          [
            ./hosts/deskmini/hardware-configuration.nix
            ./disko-raid.nix
          ]
          ++ (scanPath {
            _path = ./system;
            excludeFiles = [
              "vm.nix"
              # "backup.nix"
              # "home-merge.nix"
            ];
          });
      };
      wsl = lib.mkSys {
        hostname = "wsl";
        inherit pkgs;
        modules = [./hosts/wsl/system.nix];
        hm-modules = [./hosts/wsl/home.nix];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        hello
      ];
    };
  };
}
