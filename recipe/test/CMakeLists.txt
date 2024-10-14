cmake_minimum_required(VERSION 3.26)

project(program-using-hhdate LANGUAGES CXX)
add_executable(program main.cpp)

find_package(date REQUIRED)
target_link_libraries(program PRIVATE date::date-tz)

target_compile_features(program PRIVATE cxx_std_17)


