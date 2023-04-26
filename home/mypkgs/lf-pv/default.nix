{ pkgs, lib, ... }:
let
  my-name = "lf-pv";
  my-buildInputs = with pkgs; [
    unrar
    unzip
    p7zip # <7z>
    w3m
    poppler_utils # <pdftotext>
    highlight
    mediainfo
    chafa
    timg
  ];
  my-script = (pkgs.writeScriptBin my-name (builtins.readFile ./script.sh)).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
in
pkgs.symlinkJoin rec{
  name = my-name;
  paths = [ my-script ] ++ my-buildInputs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
}
