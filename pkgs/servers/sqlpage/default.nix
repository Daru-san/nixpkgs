{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, sqlite
, zstd
, stdenv
, darwin
, fetchurl
}:

let
  apexcharts = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/apexcharts@3.50.0/dist/apexcharts.min.js";
    hash = "sha256-pLaS+eABqnCs0TLhRUEBQVLeF7RSlW5LjsmS7eV4iKI=";
  };
  tablerCss = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css";
    hash = "sha256-lS3nKxMMZiKIRJG7UgUonOHYuvHgW5eckEjvHMYxb9Q=";
  };
  tablerVendorsCss = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler-vendors.min.css";
    hash = "sha256-Aa7AUOaz6hJLiUzQStZTy2VPOZyg0ViSo2MCzpDU1tY=";
  };
  tablerJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/js/tabler.min.js";
    hash = "sha256-ygO5OTRUtYxDDkERRwBCfq+fmakhM6ybwfl6gCCPlAQ=";
  };
  listJsFixed = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/list.js-fixed@2.3.4/dist/list.min.js";
    hash = "sha256-sYy7qNJW7RTuaNA0jq6Yrtfs57ypYrItZ3f8T7kqfPM=";
  };
  tablerIcons = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/icons-sprite@3.10.0/dist/tabler-sprite.svg";
    hash = "sha256-lEUAtxI+NffqLDllirLgcCRjEgbeCaz9Gkn3Tu9e9F4=";
  };
  tomselect = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/js/tom-select.popular.min.js";
    hash = "sha256-51NcdIM8GseVFFmg8mUWDxfhjLCA+n8kw/Ojyo+6Hjk=";
  };
in

rustPlatform.buildRustPackage rec {
  pname = "sqlpage";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "SQLpage";
    rev = "v${version}";
    hash = "sha256-ixxTaJ72EqGqvopcIr/7kRfFyK9p5laAmu7+jR5Tp1I=";
  };

  postPatch = ''
    substituteInPlace sqlpage/apexcharts.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/apexcharts@3.50.0/dist/apexcharts.min.js */' \
      "$(cat ${apexcharts})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css */' \
      "$(cat ${tablerCss})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler-vendors.min.css */' \
      "$(cat ${tablerVendorsCss})"
    substituteInPlace sqlpage/sqlpage.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/js/tabler.min.js */' \
      "$(cat ${tablerJs})"
    substituteInPlace sqlpage/sqlpage.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/list.js-fixed@2.3.4/dist/list.min.js */' \
      "$(cat ${listJsFixed})"
    substituteInPlace sqlpage/tabler-icons.svg \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/@tabler/icons-sprite@3.10.0/dist/tabler-sprite.svg */' \
      "$(cat ${tablerIcons})"
    substituteInPlace sqlpage/tomselect.js \
      --replace-fail '/* !include https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/js/tom-select.popular.min.js */' \
      "$(cat ${tomselect})"
    '';

  cargoHash = "sha256-yD82/h5dgcvp8OBfAoRfkq+YsauPncaRjfGM7dRQq5E=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      sqlite
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "SQL-only webapp builder, empowering data analysts to build websites and applications quickly";
    homepage = "https://github.com/lovasoa/SQLpage";
    changelog = "https://github.com/lovasoa/SQLpage/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "sqlpage";
  };
}
