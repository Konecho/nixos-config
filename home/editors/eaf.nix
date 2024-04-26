{pkgs, ...}:
with pkgs; let
  my-python-packages = python-packages:
    with python-packages; [
      python-lsp-server
      autopep8
      black

      pandas
      requests
      sexpdata
      tld
      pyqt6
      pyqt6-sip
      pyqt6-webengine
      epc
      lxml # for eaf
      qrcode # eaf-file-browser
      pysocks # eaf-browser
      pymupdf # eaf-pdf-viewer
      pypinyin # eaf-file-manager
      psutil # eaf-system-monitor
      retry # eaf-markdown-previewer
      markdown
    ];
  python-with-my-packages = python3.withPackages my-python-packages;
in {
  services.emacs.enable = true;
  services.emacs.client.enable = true;
  home.packages = with pkgs; [
    git
    nodejs
    wmctrl
    xdotool
    # eaf-browser
    aria
    # eaf-file-manager
    fd

    python-with-my-packages
  ];
}
