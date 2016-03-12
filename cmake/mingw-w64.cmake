# this file only serves as toolchain file when specified so explicitly
# when building the software. from repository's root directory:
# mkdir build && cd build && cmake -DCMAKE_TOOLCHAIN_FILE=$(pwd)/../cmake/mingw-w64.cmake
# -sh 20140922

SET(CMAKE_SYSTEM_NAME Windows)
SET(CMAKE_SYSTEM_VERSION 1)

# specify the cross compiler
set(p c:/mingw-w64/i686-5.3.0-posix-dwarf-rt_v4-rev0/mingw32/bin)
set(c ${p}/i686-w64-mingw32-)
#set(CMAKE_MAKE_PROGRAM ${p}/mingw32-make.exe CACHE FILEPATH "" FORCE)

set(e .exe)

SET(CMAKE_C_COMPILER    ${c}gcc${e})
SET(CMAKE_CXX_COMPILER  ${c}g++${e})
set(CMAKE_RC_COMPILER   ${c}windres${e})
set(CMAKE_LINKER        ${c}ld${e})
set(CMAKE_AR            ${c}gcc-ar${e}      CACHE STRING "" FORCE)
set(CMAKE_NM            ${c}gcc-nm${e}      CACHE STRING "" FORCE)
set(CMAKE_RANLIB        ${c}gcc-ranlib${e}  CACHE STRING "" FORCE)

SET(CMAKE_FIND_ROOT_PATH /usr/i686-w64-mingw32)

# search for programs in the host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# don't poison with system compile-time data
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# oldest CPU supported here is Northwood-based Pentium 4. -sh 20150811
set(fpu "-ffast-math -fno-finite-math-only -mfpmath=both")
set(cpu "-O3 -march=pentium4 -mtune=corei7-avx -msse -msse2 -mno-sse3 -frename-registers -fno-PIC ")

set(_CFLAGS " -fvisibility=hidden ")
set(_CXXFLAGS " -fvisibility-inlines-hidden ${_CFLAGS} ")
set(_CFLAGS_RELEASE " -s ${cpu} ${fpu} ")
set(_CFLAGS_DEBUG "-g -ggdb ${cpu} ${fpu} ")
set(_CXXFLAGS_RELEASE " ${_CFLAGS_RELEASE} ")
set(_CXXFLAGS_DEBUG " ${_CFLAGS_DEBUG} ")

set(_LDFLAGS " -Wl,--as-needed ${_CXXFLAGS} ")
set(_LDFLAGS_RELEASE " ${_CXXFLAGS_RELEASE} ")
set(_LDFLAGS_DEBUG " ${_CXXFLAGS_DEBUG} ")

foreach(j C CXX)
    foreach(i "" _DEBUG _RELEASE)
        set(OVERRIDE_${j}_FLAGS${i} "" CACHE STRING "")
        set(CMAKE_${j}_FLAGS${i} " ${_${j}FLAGS${i}} ${OVERRIDE_${j}_FLAGS${i}} " CACHE STRING "" FORCE)
    endforeach()
endforeach()

foreach (i "" _DEBUG _RELEASE)
    set(CMAKE_CXX_FLAGS${i} " ${CMAKE_CXX_FLAGS${i}} ${OVERRIDE_C_FLAGS${i}} " CACHE STRING "" FORCE)
endforeach()

foreach(j "" _DEBUG _RELEASE)
    foreach(i MODULE EXE SHARED)
        set(OVERRIDE_LDFLAGS${j} "" CACHE STRING "")
        set(CMAKE_${i}_LINKER_FLAGS${j} " ${_LDFLAGS${j}} ${OVERRIDE_LDFLAGS${j}} " CACHE STRING "" FORCE)
    endforeach()
endforeach()

set(CMAKE_BUILD_TYPE_INIT "RELEASE")
