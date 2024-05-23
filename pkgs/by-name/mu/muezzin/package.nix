{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron
}:

buildNpmPackage rec {
  pname = "muezzin";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "DBChoco";
    repo = "Muezzin";
    rev = "v${version}";
    hash = "sha256-0gQwusaqUM+QfZaDYUiWxzXIpsFS2fK48OflNTCK/58=";
  };
  buildInputs = [electron];
  npmDepsHash = "sha256-bKvlCd3116twkVrkdVKYYii9Ug7vhC/eAg3BhC3S/VM=";
  meta = with lib; {
    description = "A prayer times (Adhan) and Quran app for Windows, macOS and GNU/Linux";
    homepage = "https://github.com/DBChoco/Muezzin";
    license = licenses.mit;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "muezzin";
    platforms = platforms.all;
  };
}
