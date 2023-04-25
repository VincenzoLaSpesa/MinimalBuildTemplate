if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
	MESSAGE(STATUS "No toolchain is defined, this can cause troubles if you are cross-compiling")
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		set(OBT_64 ON)
		MESSAGE( STATUS "Running on x64")
	else()
		set(OBT_32 ON)
		MESSAGE( STATUS "Running on x86")
	endif()
else()
	MESSAGE(STATUS "Using toolchain in ${CMAKE_TOOLCHAIN_FILE} ")
endif()

set(conanFolder "${CMAKE_CURRENT_SOURCE_DIR}")
#get_filename_component(conanFolder ${conanFolder}/.. ABSOLUTE) # goes up one level
MESSAGE( STATUS "Looking for Conan in ${conanFolder}")

set(conanToolchain "${conanFolder}/${CONAN_TOOLCHAIN_FOLDER}/conanbuildinfo.cmake")
set(conanPaths "${conanFolder}/${CONAN_TOOLCHAIN_FOLDER}/conan_paths.cmake")

if(NOT EXISTS "${conanToolchain}") #this is most likely vscode running cmake
	MESSAGE(STATUS "${conanToolchain} is not valid, I'll try figure out where it is")
	
	if(EXISTS "${VSCODE_CONAN_TOOLCHAIN}/conanbuildinfo.cmake") 
		MESSAGE(STATUS "Let's try ${VSCODE_CONAN_TOOLCHAIN}")
		set(conanToolchain "${VSCODE_CONAN_TOOLCHAIN}/conanbuildinfo.cmake")
	elseif(EXISTS "${CONAN_TOOLCHAIN_FILE}") 
		MESSAGE(STATUS "${conanToolchain} is not valid, let's try ${CONAN_TOOLCHAIN_FILE}")
		set(conanToolchain "${CONAN_TOOLCHAIN_FILE}")
	endif()
endif()


if(EXISTS "${conanToolchain}")
	MESSAGE( STATUS "Using Conan as dependency manager")
	include(${conanToolchain})	
	#conan_basic_setup()	
	if(EXISTS "${conanPaths}")
		MESSAGE( STATUS "Loading cmake_paths from ${conanPaths}")
		include(${conanPaths})
	else()
		MESSAGE( STATUS "cmake_paths was not generated")
	endif()
	list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})
	list(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR})

else()
	MESSAGE(STATUS "No Conan in ${conanToolchain}")
	MESSAGE(FATAL_ERROR "Conan is needed to continue." )
endif()

