set -euxo pipefail

cmake -S . -B build ${CMAKE_ARGS} \
  -DBUILD_SHARED_LIBS=ON \
  -DUSE_SYSTEM_TZ_DB=ON \
  -DBUILD_TZ_LIB=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_STANDARD=17 \

cmake --build build --config Release --target install
