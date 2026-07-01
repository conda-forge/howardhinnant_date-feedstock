cmake_minimum_required(VERSION 3.26)

project(program-using-hhdate LANGUAGES CXX)
add_executable(program main.cpp)

option(USE_STATIC_TZ "Link date-tz statically" OFF)

find_package(date REQUIRED)
target_link_libraries(program PRIVATE date::date)

if(USE_STATIC_TZ)
  if(WIN32)
    set(_date_tz_static_names date-tz_static)
  else()
    set(_date_tz_static_names date-tz)
  endif()
  find_library(
    DATE_TZ_STATIC
    NAMES ${_date_tz_static_names}
    PATHS "$ENV{PREFIX}/lib" "$ENV{LIBRARY_PREFIX}/lib"
    NO_DEFAULT_PATH
    REQUIRED
  )
  target_link_libraries(program PRIVATE ${DATE_TZ_STATIC})
  if(UNIX)
    target_link_libraries(program PRIVATE pthread ${CMAKE_DL_LIBS})
  endif()
else()
  target_link_libraries(program PRIVATE date::date-tz)
endif()

target_compile_features(program PRIVATE cxx_std_17)
