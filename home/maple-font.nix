{ lib
, stdenv
, unzip
, fetchurl
}:

let
  maple-font = { pname, version, sha256, desc }: stdenv.mkDerivation
    rec{

      inherit pname version desc;
      src = fetchurl {
        url = "https://github.com/subframe7536/Maple-font/releases/download/v${version}/${pname}.zip";
        inherit sha256;
      };

      # Work around the "unpacker appears to have produced no directories"
      # case that happens when the archive doesn't have a subdirectory.
      setSourceRoot = "sourceRoot=`pwd`";
      nativeBuildInputs = [ unzip ];
      installPhase = ''
        find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
      '';

      meta = with lib; {
        homepage = "https://github.com/subframe7536/Maple-font";
        description = ''
          Open source ${desc} font with round corner and ligatures for IDE and command line
        '';
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ oluceps ];
      };

    };
in
{
  Mono-v6 = maple-font {
    pname = "MapleMono";
    version = "6.0";
    sha256 = "5045e80a5648b75c19ac8366467666b523cd726beb2b1de362d8c9c75b66e513";
    desc = "monospace";
  };
  Mono-NF-v6 = maple-font {
    pname = "MapleMono-NF";
    version = "6.0";
    sha256 = "09666c467a330cda832933282d3cedff1d9533295392634936127e8ba0581d6c";
    desc = "Nerd Font";
  };
  Mono-SC-NF-v6 = maple-font {
    pname = "MapleMono-SC-NF";
    version = "6.0";
    sha256 = "4f209b087cc03dae97be401a65f545c1cf0d5447a1bf11c48ca443f253ba8830";
    desc = "Nerd Font SC";
  };
}
