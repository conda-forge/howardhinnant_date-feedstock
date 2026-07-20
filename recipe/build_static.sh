set -euxo pipefail

cmake -S . -B build-static ${CMAKE_ARGS-} \
  -DBUILD_SHARED_LIBS=OFF \
  -DUSE_SYSTEM_TZ_DB=ON \
  -DBUILD_TZ_LIB=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_STANDARD=17

cmake --build build-static --config Release
cmake --install build-static --config Release

find "${PREFIX}/lib" -maxdepth 1 -name 'libdate-tz.so*' -delete
find "${PREFIX}/lib" -maxdepth 1 -name 'libdate-tz*.dylib' -delete
