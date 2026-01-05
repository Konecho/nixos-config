{
  pkgs,
  rootPath,
  ...
}: let
  writeRustBin = pname: src:
    pkgs.stdenv.mkDerivation {
      inherit pname src;
      version = "1";
      buildInputs = [pkgs.rustc];
      unpackPhase = ''true'';
      buildPhase = ''
        mkdir -p $out/bin
        rustc $src -o $out/bin/${pname}
      '';
    };
in {
  home.packages = with pkgs; (
    let
      write = name: (writeShellScriptBin name (builtins.readFile (rootPath + "/data/${name}")));
      writePy = name: (writers.writePython3Bin name {} (builtins.readFile (rootPath + "/data/${name}")));
      writeRs = name: (writeRustBin name (rootPath + "/data/${name}"));
    in [
      (writePy "catimg-pokemon.py")
      catimg
      imagemagick
      (write "nixlf")
      yazi
      jq
      chafa
      disfetch
      (
        writeShellScriptBin "pokefetch" ''
          paste <(chafa -f symbols --scale 9 "$XDG_RUNTIME_DIR/pokemon.png") <(disfetch -n)
        ''
      )
    ]
  );
}
