{
  pkgs,
  config,
  ...
}: {
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "dark";
      defaultProvider = "deepseek";
      defaultModel = "deepseek-v4-flash";
      defaultThinkingLevel = "high";
      # pi 不原生支持 MCP，通过 pi-mcp-adapter 扩展桥接。
      # 必须写在 settings.packages 而非手动 `pi install`：settings.json 是
      # home-manager 生成的 store symlink，程序运行时写不进去（会被静默吞掉）；
      # 写在这里 pi 启动时会自动补装缺失的包（装到 ~/.pi/agent/npm/，不影响
      # 只读的 settings.json）。
      packages = ["npm:pi-mcp-adapter"];
    };
    # pi-mcp-adapter 有 npm 依赖，pi 装包时需要 npm 在 PATH 上（nodejs 自带 npm）
    extraPackages = [pkgs.nodejs];
    # deepseek 是内置 provider，模型元数据（cost/context/reasoning/
    # thinkingLevelMap 等）由内置静态 catalog + pi.dev 远程 catalog 提供并
    # 自动更新。这里不要声明 models：一旦声明，models.json 会按 id 整体
    # 替换 catalog 条目（reasoning/thinkingLevelMap 等会丢失），导致无法
    # 切换 thinking。只保留 provider 层 endpoint 声明。
    models = {
      providers.deepseek = {
        baseUrl = "https://api.deepseek.com";
        api = "openai-completions";
      };
    };
  };

  # pi-mcp-adapter 读取 <Pi agent dir>/mcp.json（默认 ~/.pi/agent/mcp.json），
  # 在这里注册 mcp-nixos server。command 直接指向 nixpkgs 里的 mcp-nixos 包，
  # 运行时无需 uvx/PyPI；lifecycle=lazy 表示首次调用工具时才拉起进程。
  home.file."${config.programs.pi-coding-agent.configDir}/mcp.json".text = builtins.toJSON {
    mcpServers.nixos = {
      command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      lifecycle = "lazy";
    };
  };
}
