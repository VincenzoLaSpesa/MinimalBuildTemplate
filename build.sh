BUILD_FOLDER="build_posix"

export CONAN_REVISIONS_ENABLED=1

# remove this if you are not behind some very intrusive proxy
conan remote remove conancenter
conan remote add conancenter "https://center.conan.io" False

mkdir ${BUILD_FOLDER}
cd ${BUILD_FOLDER}
conan install .. --build=missing
cd ..

cmake -S . -B ./$BUILD_FOLDER/ -G Ninja -DCONAN_TOOLCHAIN_FOLDER:STRING=$BUILD_FOLDER
# you can use a standard makefile if you don't like Ninja ( but you will have to fix the tasks.json yourself )
#cmake -S . -B ./$BUILD_FOLDER/ -DCONAN_TOOLCHAIN_FOLDER:STRING=$BUILD_FOLDER
cmake --build ./$BUILD_FOLDER

cp -r vscode_template .vscode
python fix_vscode_paths.py ./$BUILD_FOLDER/ ./.vscode
