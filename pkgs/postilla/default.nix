{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  nasm,
  pkg-config,
  fontconfig,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "postilla";
  version = "0.2.3";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "atraxsrc";
    repo = "postilla";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4IMVXbobJLxw0baylQqOKlGReOKNH7rPbebfH9K/h6s="; # lib.fakeHash;
  };

  cargoHash = "sha256-53OjAu/2sO2zU5tK2aRmD3DsD8a9DaXtzQeDzqpysfo="; # lib.fakeHash;

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    just
    libcosmicAppHook
    nasm
    pkg-config
  ];

  buildInputs = [
    fontconfig
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  meta = {
    homepage = "https://github.com/atraxsrc/postilla";
    description = "Markdown notes for the COSMIC™ desktop";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "postilla";
  };
})
