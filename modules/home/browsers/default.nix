{pkgs, ...}: {
  imports = [
    # 半成品：扩展依赖 NUR（nixpkgs 已移除 firefox-addons），需引入 NUR 后启用
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
