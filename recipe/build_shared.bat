@echo on

cmake -S . -B build-shared %CMAKE_ARGS% -G "NMake Makefiles" ^
  -DBUILD_SHARED_LIBS=ON ^
  -DUSE_SYSTEM_TZ_DB=ON ^
  -DBUILD_TZ_LIB=ON ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_CXX_STANDARD=17 ^
  -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
if errorlevel 1 exit /b 1

cmake --build build-shared --config Release
if errorlevel 1 exit /b 1

cmake --install build-shared --config Release
if errorlevel 1 exit /b 1

if exist %LIBRARY_LIB%\date-tz_static.lib del %LIBRARY_LIB%\date-tz_static.lib
