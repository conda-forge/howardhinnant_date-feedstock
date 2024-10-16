echo on

cmake -S . -B build %CMAKE_ARGS% -G "NMake Makefiles" ^
  -DBUILD_SHARED_LIBS=ON ^
  -DUSE_SYSTEM_TZ_DB=ON ^
  -DBUILD_TZ_LIB=ON ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_CXX_STANDARD=17 ^
  -DCMAKE_CXX_STANDARD_REQUIRED=TRUE ^
  -DHAS_STRING_VIEW=1 \

if errorlevel 1 exit 1

cmake --build build --config Release --target install
if errorlevel 1 exit 1
