{
  lib,
  fetchFromGitHub,
  ffmpeg,
  icu,
  pkg-config,
  rustPlatform,
  withTranscodingCache ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "audioserve";
  version = "0.28.6";

  src = fetchFromGitHub {
    owner = "izderadicka";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4XcERhunHpDulqLn/SSZHJcQKZsaUL5AIjHeBE8d2lk=";
  };

  cargoHash = "sha256-3DB3AEiwoKj+q97/ff469OaG0iDj9C5YXag0gnfDHaY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
    icu
  ];

  nativeCheckInputs = [ ffmpeg ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  buildFeatures = [ "collation" ]
    ++ lib.optional withTranscodingCache "transcoding-cache";

  meta = with lib; {
    description = "Simple personal server to serve audiofiles files from folders.";
    homepage = "https://github.com/izderadicka/audioserve";
    license = licenses.mit;
    maintainers = with maintainers; [ muggenhor ];
  };
}
