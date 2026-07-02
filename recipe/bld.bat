@echo on

"%BUILD_PREFIX%\bin\cmake" -S . -B build-dyn %CMAKE_ARGS% -G "NMake Makefiles" ^
  -DBUILD_SHARED_LIBS=ON ^
  -DUSE_SYSTEM_TZ_DB=ON ^
  -DBUILD_TZ_LIB=ON ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_CXX_STANDARD=17 ^
  -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
if errorlevel 1 exit /b 1

"%BUILD_PREFIX%\bin\cmake" --build build-dyn --config Release
if errorlevel 1 exit /b 1

"%BUILD_PREFIX%\bin\cmake" --install build-dyn --config Release
if errorlevel 1 exit /b 1
