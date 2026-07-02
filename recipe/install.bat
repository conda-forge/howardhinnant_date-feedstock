@echo on

echo %PKG_NAME% | findstr /I /C:"static" >nul
if not errorlevel 1 goto :build_static
goto :build_shared

:build_static
"%BUILD_PREFIX%\bin\cmake" -S . -B build-static %CMAKE_ARGS% -G "NMake Makefiles" ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DUSE_SYSTEM_TZ_DB=ON ^
  -DBUILD_TZ_LIB=ON ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_RELEASE_POSTFIX="_static" ^
  -DCMAKE_CXX_STANDARD=17 ^
  -DCMAKE_CXX_STANDARD_REQUIRED=TRUE
if errorlevel 1 exit /b 1

"%BUILD_PREFIX%\bin\cmake" --build build-static --config Release
if errorlevel 1 exit /b 1

"%BUILD_PREFIX%\bin\cmake" --install build-static --config Release
if errorlevel 1 exit /b 1
goto :eof

:build_shared
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
goto :eof
