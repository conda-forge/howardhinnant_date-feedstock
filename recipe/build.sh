#!/bin/bash

# on osx, uncaught_exceptions() is not defined. Exclude that as per: https://github.com/HowardHinnant/date/issues/673 
if [ $target_platform == "osx-64" ]; then
	CMAKE_CXX_FLAGS="-DCMAKE_CXX_FLAGS=-DHAS_UNCAUGHT_EXCEPTIONS=0"
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # Get an updated config.sub and config.guess:
  # See https://conda-forge.org/docs/maintainer/knowledge_base.html#cross-compilation
  cp $BUILD_PREFIX/share/gnuconfig/config.* .
fi

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX $SRC_DIR -DCMAKE_INSTALL_LIBDIR=lib -DBUILD_SHARED_LIBS=ON -DUSE_SYSTEM_TZ_DB=ON -DBUILD_TZ_LIB=ON -DCMAKE_CXX_FLAGS="-fPIC" -DCMAKE_BUILD_TYPE=Release $CMAKE_CXX_FLAGS
make
make install
