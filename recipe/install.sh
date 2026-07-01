set -euxo pipefail

CMAKE="${BUILD_PREFIX}/bin/cmake"

if [[ "${PKG_NAME}" == *static ]]; then
  "${CMAKE}" -S . -B build-static ${CMAKE_ARGS} \
    -DBUILD_SHARED_LIBS=OFF \
    -DUSE_SYSTEM_TZ_DB=ON \
    -DBUILD_TZ_LIB=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17

  "${CMAKE}" --build build-static --config Release
  "${CMAKE}" --install build-static --config Release
else
  "${CMAKE}" -S . -B build-dyn ${CMAKE_ARGS} \
    -DBUILD_SHARED_LIBS=ON \
    -DUSE_SYSTEM_TZ_DB=ON \
    -DBUILD_TZ_LIB=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17

  "${CMAKE}" --build build-dyn --config Release
  "${CMAKE}" --install build-dyn --config Release
fi
