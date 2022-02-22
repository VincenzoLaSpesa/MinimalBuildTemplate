"""
    guess the include path from a conanbuildinfo.txt and populate a c_cpp_properties.json with it
"""
import pathlib
import sys
import os
import json

def collect(filename: str) -> list:
    collecting=False
    collector=[]
    with open(filename) as file:
        for line in file:
            token=line.strip()
            if token.startswith("["):
                if token.startswith("[includedirs]"):
                    collecting=True
                else:
                    collecting=False
            elif collecting and len(token) > 0:
                collector.append(token)


    return collector

# main

if(len(sys.argv) < 3):
    sys.exit("wrong arguments. syntax is:\n\t fix_vscode_paths.py build_folder vscode_folder")

conan_folder=sys.argv[1]
vscode_folder=sys.argv[2]
basedir=pathlib.Path().resolve()

items=[]
try:
    fullpath=os.path.join(basedir, conan_folder, "conanbuildinfo.txt")
    print("Reading conan configurations from", fullpath)

    items=collect(fullpath)
    print(items)

except Exception as e:
    print("Unable to read the conan configuration. Did the build process work?")
    print(e)
    exit(-1)

try:
    fullpath=os.path.join(basedir, vscode_folder, "c_cpp_properties.json")
    print("Adding the include folders to", fullpath)

    data={}
    with open(fullpath, 'r') as f:
        data=json.load(f)

    for conf in data['configurations']:
        for i in items:
            conf['includePath'].append(i+"/**")

    s=json.dumps(data, indent=1)
    print(s)

    with open(fullpath, 'w') as f:
        f.write(s)

except Exception as e:
    print("Unable to write the vscode configuration. Did the build process work?")
    print(e)
    exit(-1)
