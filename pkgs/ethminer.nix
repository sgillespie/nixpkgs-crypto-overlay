{
  fetchFromGitHub,
  opencl-headers,
  cmake,
  jsoncpp,
  boost,
  makeWrapper,
  mesa,
  ethash,
  opencl-info,
  rocm-opencl-icd,
  rocm-opencl-runtime,
  rocm-smi,
  openssl,
  pkg-config,
  cli11,
  stdenv,
  xdg_utils
}:
  
stdenv.mkDerivation rec {
  pname = "ethminer";
  version = "0.18.0";

  src =
    fetchFromGitHub {
      owner = "ethereum-mining";
      repo = "ethminer";
      rev = "v${version}";
      sha256 = "10b6s35axmx8kyzn2vid6l5nnzcaf4nkk7f5f7lg3cizv6lsj707";
      fetchSubmodules = true;
    };

  # NOTE: dbus is broken
  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DETHASHCUDA=OFF"
    "-DAPICORE=ON"
    "-DETHDBUS=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    cli11
    boost
    opencl-headers
    mesa
    ethash
    opencl-info
    rocm-opencl-icd
    rocm-opencl-runtime
    rocm-smi
    openssl
    jsoncpp
    xdg_utils
  ];

  preConfigure = ''
    sed -i 's/_lib_static//' libpoolprotocols/CMakeLists.txt
  '';

  postInstall = ''
    wrapProgram $out/bin/ethminer \
       --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
  '';

  meta = with stdenv.lib; {
    description = "Ethereum miner with OpenCL and stratum support";
    homepage = "https://github.com/ethereum-mining/ethminer";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nand0p ];
    license = licenses.gpl2;
    # Doesn't build with gcc9, and if overlayed to use gcc8 stdenv fails on CUDA issues.
    broken = false;
  };
}
