cmake_minimum_required(VERSION 3.0)
project(curlite)

# for unix platform, define install directories.
include(GNUInstallDirs)

set(CMAKE_CXX_STANDARD 14)

if(POLICY CMP0042)
    cmake_policy(SET CMP0042 NEW) # MACOSX_RPATH
    set(CMAKE_MACOSX_RPATH TRUE)
endif()


#-----curl begin ----
message(STATUS "-----------------------")
message(STATUS "Looking for CURL")
message(STATUS "-----------------------")
include(FindCURL)
find_package(CURL REQUIRED)

if(CURL_FOUND)
    message(STATUS "Found CURL version: ${CURL_VERSION_STRING}")
    message(STATUS "Using CURL include dir(s): ${CURL_INCLUDE_DIRS}")
    message(STATUS "Using CURL lib(s): ${CURL_LIBRARIES}")
else()
    message(FATAL_ERROR "Could not find CURL")
endif()

#---- curl end --

set(CURLITE_SOURCE_DIR                ".")
set(CURLITE_INCLUDE_INSTALL_DIR       "include")
set(CURLITE_HEADER_INSTALL_DIR        "${CURLITE_INCLUDE_INSTALL_DIR}/curlite")
################################
# set lib version here

set(GENERIC_LIB_VERSION "1.0.1")
set(GENERIC_LIB_SOVERSION "1")

set(SOURCE_FILES ${CURLITE_SOURCE_DIR}/curlite.cpp ${CURLITE_SOURCE_DIR}/curlite.hpp)

# All following targets should search these directories for headers
include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CURL_INCLUDE_DIRS}
)

option(CURLITE_BUILD_SHARED_LIBS "build as shared library" OFF)
option(CURLLITE_BUILD_STATIC_LIBS "build as static library" ON)

if(CURLITE_BUILD_SHARED_LIBS)
    message(STATUS "-----------------------")
    message(STATUS "curlite building shared lib")
    message(STATUS "-----------------------")
    add_library(curlite SHARED ${SOURCE_FILES})

    set_target_properties(curlite PROPERTIES
            COMPILE_DEFINITIONS "CURLITE_EXPORT"
            VERSION "${GENERIC_LIB_VERSION}"
            SOVERSION "${GENERIC_LIB_SOVERSION}")



    if(DEFINED CMAKE_VERSION AND NOT "${CMAKE_VERSION}" VERSION_LESS "2.8.11")
        target_include_directories(curlite PUBLIC
                $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
                $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include>)

        if(MSVC)
            target_compile_definitions(curlite PUBLIC -D_CRT_SECURE_NO_WARNINGS)
        endif(MSVC)
    else()
        include_directories(${PROJECT_SOURCE_DIR})

        if(MSVC)
            add_definitions(-D_CRT_SECURE_NO_WARNINGS)
        endif(MSVC)
    endif()


    # export targets for find_package config mode
    export(TARGETS curlite
            FILE ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake)

    install(TARGETS curlite
            EXPORT ${CMAKE_PROJECT_NAME}Targets
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

    target_link_libraries(curlite ${CURL_LIBRARIES})

endif()



if(CURLLITE_BUILD_STATIC_LIBS)
    message(STATUS "-----------------------")
    message(STATUS "building static lib for curlite")
    message(STATUS "-----------------------")


    add_library(curlite_static STATIC ${SOURCE_FILES})

    set_target_properties(curlite_static PROPERTIES
            COMPILE_DEFINITONS "CURLITE_EXPORT"
            VERSION "${GENERIC_LIB_VERSION}"
            SOVERSION "${GENERIC_LIB_SOVERSION}")
    set_target_properties( curlite_static PROPERTIES OUTPUT_NAME curlite )
    target_link_libraries(curlite_static ${CURL_LIBRARIES})


    export(TARGETS curlite_static
            FILE ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake)

    install(TARGETS curlite_static
            EXPORT ${CMAKE_PROJECT_NAME}Targets
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            )

    if(DEFINED CMAKE_VERSION AND NOT "${CMAKE_VERSION}" VERSION_LESS "2.8.11")
        target_include_directories(curlite_static PUBLIC
                $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
                $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include>)

        if(MSVC)
            target_compile_definitions(curlite_static PUBLIC -D_CRT_SECURE_NO_WARNINGS)
        endif(MSVC)
    else()
        include_directories(${PROJECT_SOURCE_DIR})

        if(MSVC)
            add_definitions(-D_CRT_SECURE_NO_WARNINGS)
        endif(MSVC)
    endif()
endif()

install(FILES ${CURLITE_SOURCE_DIR}/curlite.hpp DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

foreach(p LIB INCLUDE)
    set(var CMAKE_INSTALL_${p}DIR)
    if(NOT IS_ABSOLUTE "${${var}}")
        set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
    endif()
endforeach()


file(WRITE
        ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
        "include(\${CMAKE_CURRENT_LIST_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake)\n")

install(FILES
        ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
        DESTINATION lib/cmake/${CMAKE_PROJECT_NAME})

install(EXPORT ${CMAKE_PROJECT_NAME}Targets
        DESTINATION lib/cmake/${CMAKE_PROJECT_NAME})
