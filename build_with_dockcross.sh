#!/bin/sh

# run with something like ./dockcross-linux-armv7 bash -c './build_with_dockcross.sh'
#	dockcross is this project here https://github.com/dockcross/dockcross 

#	@TODO having conan implies having python, and having dockcross implies having conan, using python for the build script could be a nice idea

git config --global --add safe.directory /work
BASE_FOLDER=`pwd`
mkdir build_cross || (cd build_cross && rm -r *) 
cd build_cross ; BUILD_FOLDER=`pwd` ; cd $BASE_FOLDER

cp $BASE_FOLDER/conan_profiles/gcc10_armv7_linux.profile ${BUILD_FOLDER}/baked_profile.profile -v

rm -r dist

export CONAN_REVISIONS_ENABLED=1

# remove this if you are not behind some evil proxy
conan remote remove conancenter
conan remote add conancenter1 "https://center.conan.io" False #conan1 syntax, will fail if conan2
conan remote add conancenter2 "https://center.conan.io" --insecure  --force #conan2 syntax, will fail if conan1

cd ${BUILD_FOLDER}
cp ../conanfile.txt . -v 

conan profile detect # currently dockcross does not fully support conan2
FILE=./baked_profile.profile
if test -f "$FILE"; then
    echo "Forcing the profile with $FILE"
    conan install . --build=missing --profile:host=$FILE --profile:build=default
else
    conan install . --build=missing
fi


cd ..
mkdir dist
cmake -S . -B $BUILD_FOLDER/ -DCONAN_TOOLCHAIN_FOLDER:STRING=$BUILD_FOLDER -DCONAN_TOOLCHAIN_FILE:STRING=$BUILD_FOLDER/conan_toolchain.cmake -DCMAKE_INSTALL_PREFIX:STRING=./dist

cmake --build $BUILD_FOLDER -DCMAKE_INSTALL_PREFIX=$BASE_FOLDER/dist
cd $BUILD_FOLDER
make install
mv ./dist $BASE_FOLDER/dist
