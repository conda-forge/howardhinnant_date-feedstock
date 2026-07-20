set -euxo pipefail

cmake -S . -B build-shared ${CMAKE_ARGS-} \
  -DBUILD_SHARED_LIBS=ON \
  -DUSE_SYSTEM_TZ_DB=ON \
  -DBUILD_TZ_LIB=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_STANDARD=17

cmake --build build-shared --config Release
cmake --install build-shared --config Release

rm -f "${PREFIX}/lib/libdate-tz.a"
