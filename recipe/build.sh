#!/bin/bash

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # Get an updated config.sub and config.guess:
  # See https://conda-forge.org/docs/maintainer/knowledge_base.html#cross-compilation
  cp $BUILD_PREFIX/share/gnuconfig/config.* .
fi

cmake -S . -B build ${CMAKE_ARGS} \
  -DBUILD_SHARED_LIBS=ON \
  -DUSE_SYSTEM_TZ_DB=ON \
  -DBUILD_TZ_LIB=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_STANDARD=17 \

cmake --build build --config Release --target install
