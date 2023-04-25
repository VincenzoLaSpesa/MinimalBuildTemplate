cmake_minimum_required (VERSION 3.20)
#set(CMAKE_FIND_DEBUG_MODE 1)

project(minimal_build_template VERSION 3 LANGUAGES C CXX)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
	MESSAGE(STATUS "No toolchain is defined")
else()
	MESSAGE(STATUS "Using toolchain in ${CMAKE_TOOLCHAIN_FILE}")
endif()

if(EXISTS "ConanWrapper.cmake")
	include("ConanWrapper.cmake")
elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ConanWrapper.cmake")
	# vscode will try to run cmake again, and it will fuck the paths if i don't trick him
	# if it's still fucked you can still build from Ninja, but the debugger will not work out of the box
	MESSAGE( STATUS "--> Loading the conan wrapper from ${CMAKE_CURRENT_SOURCE_DIR}/ConanWrapper.cmake")
	MESSAGE( STATUS "--> Running from Visual Studio Code?")
	set(VSCODE_CONAN_TOOLCHAIN "${CMAKE_CURRENT_SOURCE_DIR}/build_posix/")
	include("${CMAKE_CURRENT_SOURCE_DIR}/ConanWrapper.cmake")
else()
	MESSAGE( STATUS "Conan is not used, there is no ConanWrapper.cmake here")
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(OBT_64 ON)
	MESSAGE( STATUS "Running on x64")
else()
	set(OBT_32 ON)
	MESSAGE( STATUS "Running on x86")
endif()

MESSAGE( STATUS "Looking for libs ... " )
# some common libs
  find_package(fmt REQUIRED) # this is needed by the sample
  
  #find_package(Boost REQUIRED)
  #find_package(asio REQUIRED)
  
  #find_package(Threads REQUIRED )
  #MESSAGE(STATUS "--> Pthread in " ${CMAKE_THREAD_LIBS_INIT})#pthread library
  
MESSAGE( STATUS "All libs found. " )

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)


set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(PROJECT_INSTALL_DIR "bin")

add_subdirectory(src)
