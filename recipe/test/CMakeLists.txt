cmake_minimum_required(VERSION 3.26)

project(program-using-hhdate LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

add_executable(program main.cpp)

find_package(date REQUIRED)
target_link_libraries(program PRIVATE date::date-tz)
