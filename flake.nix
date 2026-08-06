{
  description = "个人 NixOS 配置（blueprint 目录结构）";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    preservation.url = "github:nix-community/preservation";
    # follow 主 nixpkgs：包与系统同源构建
    my-nixpkgs = {
      url = "github:Konecho/my-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    # 上游 main 已修复 home-manager 选项搜索，未发 release；overlay 临时指向 main，
    # nixpkgs 更新到修复版后可删 input + overlay
    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "";
    };
    # 单用户接线见 modules/nixos/user.nix（用户名由 blueprint 目录名读取）
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur.follows = "";
    };
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # blueprint：目录结构 → flake 输出的一一映射
    blueprint = {
      url = "github:numtide/blueprint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # niri = {
    #   url = "github:niri-wm/niri";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    minegrub-theme = {
      url = "github:Lxtharia/minegrub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # minegrub-world-sel-theme = {
    #   url = "github:Lxtharia/minegrub-world-sel-theme";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    minecraft-plymouth-theme = {
      url = "github:nikp123/minecraft-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minesddm = {
      url = "github:Davi-S/sddm-theme-minesddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    # noctalia.nix 已注释（半成品），input 暂不启用
    # caelestia = {
    #   url = "github:jutraim/niri-caelestia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.quickshell.follows = "quickshell";
    # };
    # ambxst = {
    #   url = "github:Axenide/Ambxst";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    hexecute = {
      url = "github:ThatOtherAndrew/Hexecute";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     home-manager.follows = "home-manager";
    #   };
    # };
    # zen-browser.nix / librewolf.nix 已注释（依赖 NUR），input 暂不启用
    # not flake
    # pokesprite = {
    #   url = "github:msikma/pokesprite";
    #   flake = false;
    # };
  };

  outputs = inputs: let
    toml = builtins.fromTOML (builtins.readFile ./config.toml);
    # mcp-nixos 2.4.3 的 options.xhtml 已失效（home-manager 文档改版为 JS 重定向）；
    # 用上游 main 的 lib.mkMcpNixos，不用 overlays.default（其 fastmcp3 overlay 会降级 fastmcp）
    mcpNixosOverlay = final: prev: {
      mcp-nixos = inputs.mcp-nixos.lib.mkMcpNixos {pkgs = final;};
    };
  in
    # blueprint：目录结构生成全部 flake 输出（映射表见 docs/blueprint.md）
    inputs.blueprint {
      inherit inputs;
      systems = ["x86_64-linux"];
      # 用户信息（config.toml）驱动的 nixpkgs 配置：unfree/insecure 白名单
      nixpkgs = {
        config = {
          allowUnfreePredicate = pkg:
            builtins.elem (inputs.nixpkgs.lib.getName pkg) toml.pkgs.unfree;
          permittedInsecurePackages = toml.pkgs.insecure;
        };
        overlays = [
          (final: prev: {
            mypkgs = inputs.my-nixpkgs.packages.${final.stdenv.hostPlatform.system};
          })
          mcpNixosOverlay
        ];
      };
    };
}
