{
  ...
}: {
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "dark";
      defaultProvider = "deepseek";
      defaultModel = "deepseek-v4-flash";
      defaultThinkingLevel = "high";
    };
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
}
