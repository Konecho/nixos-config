# checks/yazi.nix
# 校验 yazi 配置生成的 yazi.toml/keymap.toml/init.lua 可被当前版本解析，并冒烟测试 epub 预览。
# 回归点：规则 name→url（26.x）；epub 规则不得依赖 mime（file(1) 对 container.xml 居首的
# epub 识别为 application/zip）；exiftool→jq→glow 管道处理非标准 epub
{
  pkgs,
  flake,
  system,
  ...
}: let
  lib = pkgs.lib;
  # homeConfigurations 挂在 legacyPackages.<system> 下（nix3 .# 自动前缀）
  homes = flake.legacyPackages.${system}.homeConfigurations;
  users = builtins.attrNames homes;

  # 每个用户的 yazi 配置生成物（source 是 derivation，check 会把它构建出来）
  userCfg = name: let
    cfg = homes.${name}.config;
  in {
    yaziToml = cfg.xdg.configFile."yazi/yazi.toml".source;
    keymapToml = cfg.xdg.configFile."yazi/keymap.toml".source;
    initLua = cfg.xdg.configFile."yazi/init.lua".source;
    plugins = lib.filterAttrs (k: _: lib.hasPrefix "yazi/plugins/" k) cfg.xdg.configFile;
  };

  # 从配置里取出 epub 预览规则的实际 run 命令，check 照原样执行
  epubRule = lib.findFirst (r: (r.url or "") == "*.epub") null (
    homes.${builtins.head users}.config.programs.yazi.settings.plugin.prepend_previewers
  );

  # 组装 XDG_CONFIG_HOME 后 yazi --help 验证（--help 解析全部配置，规则错误在此暴露）
  configSteps = lib.concatStringsSep "\n" (map (name: let
      c = userCfg name;
    in ''
      echo "== ${name}: yazi --help 解析配置"
      d=$out/xdg-${name}/yazi
      mkdir -p $d/plugins
      cp ${c.yaziToml} $d/yazi.toml
      cp ${c.keymapToml} $d/keymap.toml
      cp ${c.initLua} $d/init.lua
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "cp -r ${v.source} $d/plugins/$(basename ${v.target})") c.plugins)}
      # piper 折行补丁回归防护（glow -w 只在空格处折行，CJK 折行依赖此补丁）
      grep -q "ui.Wrap.YES" $d/plugins/piper.yazi/main.lua || {
        echo "piper 折行补丁未生效（modules/home/commandline/piper-wrap.patch）"
        exit 1
      }
      XDG_CONFIG_HOME=$out/xdg-${name} XDG_STATE_HOME=$out/state-${name} ${pkgs.yazi}/bin/yazi --help >/dev/null
    '')
    users);

  # 同 piper 调用方式：sh -c '<run>' sh <文件>（$1/$w/$h/$t 由 piper 设置）
  epubCmd = lib.removePrefix "piper -- " epubRule.run;
in
  assert lib.assertMsg (epubRule != null)
  "checks/yazi.nix: yazi 配置里没有 url = \"*.epub\" 的预览规则（modules/home/commandline/yazi.nix 改动过？）";
    pkgs.runCommand "check-yazi-config" {
      nativeBuildInputs = [
        pkgs.yazi
        pkgs.python3
        pkgs.exiftool
        pkgs.jq
        pkgs.glow
      ];
    } ''
        set -euo pipefail
        ${configSteps}

        echo "== epub 预览管道冒烟测试（container.xml 居首、非 OCF 标准结构的 epub）"
        python3 <<'PYEOF'
      import zipfile

      with zipfile.ZipFile("fixture.epub", "w") as z:
          # 复现真实结构：container.xml 居首且 deflate（file(1) 识别为 zip，规则不得依赖 mime）
          z.writestr(
              "META-INF/container.xml",
              """<?xml version="1.0" encoding="UTF-8"?>
      <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
        <rootfiles>
          <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
        </rootfiles>
      </container>""",
          )
          z.writestr("mimetype", "application/epub+zip", compress_type=zipfile.ZIP_DEFLATED)
          z.writestr(
              "OEBPS/content.opf",
              """<?xml version="1.0" encoding="UTF-8"?>
      <package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="uid">
        <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
          <dc:identifier id="uid">urn:uuid:00000000-0000-0000-0000-000000000000</dc:identifier>
          <dc:title>check-fixture</dc:title>
          <dc:creator>nix-check</dc:creator>
        </metadata>
      </package>""",
          )
      PYEOF
        echo ${lib.escapeShellArg "== run 命令：${epubCmd}"}
        out=$(w=60 h=40 t=dark sh -c ${lib.escapeShellArg epubCmd} sh fixture.epub 2>/dev/null)
        printf '%s' "$out" | grep "check-fixture" >/dev/null
        echo "== 全部通过"
        touch $out
    ''
