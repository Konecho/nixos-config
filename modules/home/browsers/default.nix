{pkgs, ...}: {
  imports = [
    # 半成品：librewolf / zen-browser 的扩展列表依赖 NUR（rycee.firefox-addons），
    # nixpkgs 已移除 firefox-addons；需引入 NUR 或改用其它扩展来源后再启用
    # ./librewolf.nix
    # ./zen-browser.nix
  ];
  programs.qutebrowser.enable = true;
  home.sessionVariables.BROWSER = "qutebrowser";
  home.packages = with pkgs; [
    # surf
    # microsoft-edge
    # google-chrome
    # vivaldi
    # firefox
    # firefox-devedition
    # librewolf
  ];
}
