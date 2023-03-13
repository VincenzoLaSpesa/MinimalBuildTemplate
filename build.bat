@echo off
pushd ..
set ABS_PATH=%CD%
popd

set TOOLCHAIN="put here a vcpkg toolchain, if you need it"
set TARGET1="Visual Studio 16 2019"
set TARGET2="Visual Studio 15 2017"
set TARGET3="Visual Studio 9 2008"

set CONAN_REVISIONS_ENABLED=1

@echo on
mkdir build
cd build
conan install .. --build=missing --profile ../conan_profiles/vs2017_x64.profile
cd ..

cmake -S . -B .\build\ -G %TARGET2% -A x64 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCONAN_TOOLCHAIN_FOLDER:STRING=build
cmake --build .\build --config RelWithDebInfo 
