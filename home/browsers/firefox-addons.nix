{
  rycee-addons,
  stdenv,
  fetchgit,
  zip,
}:
with rycee-addons; [
  violentmonkey
  kiss-translator
  augmented-steam
  (buildFirefoxXpiAddon rec {
    pname = "bewlybewly";
    version = "0.41.1";
    addonId = "addon@bewlybewly.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4444302/${pname}-${version}.xpi";
    sha256 = "sha256-mzKbUflAhY5uHVe0cTonqZ0rqQhHsAiX/JSveXHkVho=";
    meta.homepage = "https://github.com/bewlybewly/bewlybewly";
  })
  bitwarden
  floccus
  (stdenv.mkDerivation rec {
    pname = "hydrus-companion";
    version = "3.2";
    src = fetchgit {
      url = "https://gitgud.io/prkc/hydrus-companion.git";
      rev = "789235938b756c7ef0a001bec95166518ed39f90";
      sha256 = "sha256-F8s27k2CsRb6VzpC/0D4hRzOl1FlBYXZA/cj3x/WqxY=";
    };
    buildInputs = [zip];
    installPhase = ''
      APP_ID="{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      EXT_ID="hydruscompanion@hydruscompanion.hydruscompanion"
      target="$out/share/mozilla/extensions/$APP_ID/$EXT_ID"
      rm -f manifest.json
      cp firefox-manifest.json manifest.json
      install -d "$target"
      cp -r . "$target"
      zip -r $target.xpi . -x '*.git*'
    '';
  })
  (buildFirefoxXpiAddon rec {
    pname = "powerfulpixivdownloader";
    version = "18.2.0";
    addonId = "PowerfulPixivDownloader@pixiv.download";
    url = "https://addons.mozilla.org/firefox/downloads/file/4629086/${pname}-${version}.xpi";
    sha256 = "sha256-ldKA1InWqQMnIP0MpfqAKHthd7P795B6otINnlcgoR4=";
    meta.homepage = "https://github.com/xuejianxianzun/PixivBatchDownloader";
  })
  (buildFirefoxXpiAddon rec {
    pname = "scroll_anywhere";
    version = "9.2";
    addonId = "juraj.masiar@gmail.com_ScrollAnywhere";
    url = "https://addons.mozilla.org/firefox/downloads/file/3938344/${pname}-${version}.xpi";
    sha256 = "614a7a13baad91a4015347ede83b66ae3e182679932cfc4ccd8fa5604ab38e91";
    meta.homepage = "https://fastaddons.com/";
  })
  tree-style-tab
  ublock-origin
  vimium-c
  web-archives
]
