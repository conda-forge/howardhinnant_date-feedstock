@echo on

cd /d %~dp0

python check_package_libs.py static
if errorlevel 1 exit 1

if not exist "%LIBRARY_PREFIX%\include\date\date.h" exit 1
if not exist "%LIBRARY_PREFIX%\cmake\dateConfig.cmake" exit 1

cmake . -GNinja -DCMAKE_BUILD_TYPE=Release -DUSE_STATIC_TZ=ON
if errorlevel 1 exit 1
cmake --build . --config Release
if errorlevel 1 exit 1
mklink %PREFIX%\share\zoneinfo\CondaTest %PREFIX%\share\zoneinfo\UTC
if errorlevel 1 exit 1
program.exe
if errorlevel 1 exit 1
