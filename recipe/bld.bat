
set "CXXFLAGS=%CXXFLAGS% -DINSTALL=%LIBRARY_PREFIX%\share\zoneinfo"

cmake -G "NMake Makefiles" ^
     -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
     %SRC_DIR% ^
     -D BUILD_SHARED_LIBS=ON ^
     -D BUILD_TZ_LIB=ON ^
     -D USE_SYSTEM_TZ_DB=ON ^
     -D CMAKE_BUILD_TYPE=Release ^
     -D CMAKE_VERBOSE_MAKEFILE=ON

if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
