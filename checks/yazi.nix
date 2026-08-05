# checks/yazi.nix
# 校验 yazi 配置（modules/home/commandline/yazi.nix）生成的 yazi.toml / keymap.toml /
# init.lua 能被当前 yazi 版本解析，并用配置里实际的 epub 预览命令做冒烟测试。
#
# 覆盖的回归点：
# - 规则字段 name → url（yazi 26.x 改名为 url，name 被忽略，且 26.5.6 起校验
#   报错 "at least one of `url` or `mime` must be specified"）
# - epub 预览规则不得依赖 mime：file(1) 5.48 只在 OCF 标准结构（mimetype 是
#   首个未压缩成员）下识别为 application/epub+zip，container.xml 居首的 epub
#   会被识别为 application/zip，mime 条件永不匹配而落到 ouch/hexyl
# - epub 预览管道（exiftool → jq → glow）能处理 container.xml 居首的非标准 epub
{
  pkgs,
  flake,
  system,
  ...
}: let
  lib = pkgs.lib;
  # blueprint 把 homeConfigurations 挂在 legacyPackages.<system>.homeConfigurations
  # （顶层没有；nix3 的 .#homeConfigurations 能通是 legacyPackages 自动前缀）
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

  # 逐用户：组装 XDG_CONFIG_HOME 后用 yazi --help 验证配置可解析
  #（--help 会先解析全部配置，规则字段错误会在这里暴露）
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

  # 与 piper 插件相同的调用方式：sh -c '<run 去掉 "piper -- " 前缀>' sh <文件>
  #（$1 = 文件路径，$w/$h/$t = 预览区宽高/明暗主题，piper 会设置这些环境变量）
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
          # 复现用户真实文件结构：container.xml 是第一个成员且 deflate，
          # mimetype 反而在后面（file(1) 因此识别为 application/zip，规则不得依赖 mime）
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
