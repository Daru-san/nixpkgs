{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hours";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "hours";
    rev = "v${version}";
    hash = "sha256-71vIXwt08c3LrFL5zYUW6b01gOX/Mg4ymiymvtcchII=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A no-frills time tracking toolkit for command line nerds";
    homepage = "https://github.com/dhth/hours";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "hours";
  };
}
