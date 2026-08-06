{
  pkgs,
  config,
  ...
}: {
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "light";
      defaultProvider = "deepseek";
      defaultModel = "deepseek-v4-flash";
      defaultThinkingLevel = "high";
      # pi 不原生支持 MCP，经 pi-mcp-adapter 桥接；写 settings.packages 而非 `pi install`
      # （settings.json 是 store symlink，程序写不进；pi 启动时自动补装到 ~/.pi/agent/npm/）
      packages = [
        "npm:pi-mcp-adapter"
        # web 搜索/URL 抓取/PDF 提取等（npm 包，pi 启动时自动补装）
        "npm:pi-web-access"
        "npm:pi-deepseek-search"
        "npm:@alexanderfortin/pi-deepseek-usage"
      ];
    };
    # pi-mcp-adapter 有 npm 依赖，pi 装包时需要 npm 在 PATH 上（nodejs 自带 npm）
    extraPackages = [pkgs.nodejs];
    # 内置 provider 勿声明 models：同 id 整体覆盖 catalog 条目（丢失
    # reasoning/thinkingLevelMap，无法切换 thinking）；只保留 provider 层声明
    models = {
      providers.deepseek = {
        baseUrl = "https://api.deepseek.com";
        api = "openai-completions";
      };
    };
  };

  # 注册 mcp-nixos（mcp.json 默认 ~/.pi/agent/mcp.json；command 直指 nixpkgs 包，
  # 无需 uvx；lifecycle=lazy 首次调用才拉起）
  home.file."${config.programs.pi-coding-agent.configDir}/mcp.json".text = builtins.toJSON {
    mcpServers.nixos = {
      command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      lifecycle = "lazy";
    };
  };
}
