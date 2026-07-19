{
  inputs,
  stdenv,
  gradle_8,
  jdk21,
  makeWrapper,
  lib,
}:
let
  gradle = gradle_8;
  jdk = jdk21;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "baritone-meteor";
  version = "1.17.0+1.21.11";

  src = inputs.self;

  nativeBuildInputs = [
    gradle
    jdk
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  gradleBuildTask = "fabric:build";

  doCheck = true;

  installPhase = ''
    mkdir -p $out
    cp dist/*.jar $out/
  '';

  meta.sourceProvenance = with lib.sourceTypes; [
    fromSource
    binaryBytecode
  ];
})
