{
  pkgs,
  rootPath,
  ...
}: {
  home.packages = with pkgs; (
    let
      write = name: (writeShellScriptBin name (builtins.readFile (rootPath + "/data/${name}")));
      writePy = name: (writers.writePython3Bin name {} (builtins.readFile (rootPath + "/data/${name}")));
    in [
      (writePy "catimg-pokemon.py")
      catimg
      imagemagick
      (write "nixlf")
      yazi
      jq
    ]
  );
}
