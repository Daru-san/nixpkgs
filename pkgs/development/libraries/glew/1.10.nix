{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libXmu,
  libXi,
  libXext,
  testers,
  mesa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glew";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/glew-${finalAttrs.version}.tgz";
    sha256 = "01zki46dr5khzlyywr3cg615bcal32dazfazkf360s1znqh17i4r";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libXmu
    libXi
    libXext
  ];
  propagatedBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libGLU ]; # GL/glew.h includes GL/glu.h

  outputs = [
    "out"
    "dev"
  ];

  patchPhase = ''
    sed -i 's|lib64|lib|' config/Makefile.linux
    ${lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      sed -i -e 's/\(INSTALL.*\)-s/\1/' Makefile
    ''}
  '';

  buildFlags = [ "all" ];
  installFlags = [ "install.all" ];

  preInstall = ''
    export GLEW_DEST="$out"
  '';

  postInstall = ''
    mkdir -pv $out/share/doc/glew
    mkdir -p $dev/lib/pkgconfig
    cp glew*.pc $dev/lib/pkgconfig
    cp -r README.txt LICENSE.txt doc $out/share/doc/glew
  '';

  makeFlags = [
    "SYSTEM=${if stdenv.hostPlatform.isMinGW then "mingw" else stdenv.hostPlatform.parsed.kernel.name}"
    "CC:=$(CC)"
    "LD:=$(CC)"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "OpenGL extension loading library for C(++)";
    homepage = "https://glew.sourceforge.net/";
    license = licenses.free; # different files under different licenses
    #["BSD" "GLX" "SGI-B" "GPL2"]
    pkgConfigModules = [ "glew" ];
    inherit (mesa.meta) platforms;
  };
})
