cmake_minimum_required(VERSION 3.4.1)

project(curlite)

add_library( # Specifies the name of the library.
        curlite STATIC
        ./curlite.cpp)

include_directories(${CMAKE_CURRENT_LIST_DIR})
include_directories(${CMAKE_CURRENT_LIST_DIR}/../curl)
include_directories(${CMAKE_CURRENT_LIST_DIR}/../curl/include)