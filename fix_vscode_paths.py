"""
    guess the include path from a conanbuildinfo.txt and populate a c_cpp_properties.json with it
"""
import pathlib
import sys
import os
import json
import traceback

def list_get_uniq(l: list) -> list:
    seen = set()
    outlist=[]
    for x in l:
        if x not in seen:
            seen.add(x)
            outlist.append(x)
    return outlist

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
    print("Conan includes are in:\n",json.dumps(items, indent=1),"\n")

except Exception as e:
    print("Unable to read the conan configuration. Did the build process work?")
    print(e)
    exit(-1)

try:
    fullpath=os.path.join(basedir, vscode_folder, "c_cpp_properties.json")
    print("Adding the include folders to", fullpath)
    conan_env=[{'VSCODE_CONAN_TOOLCHAIN_FOLDER' : os.path.abspath("./build_posix/")}]

    data={}
    with open(fullpath, 'r') as f:
        data=json.load(f)

    for conf in data['configurations']:
        for i in items:
            conf['includePath'].append(i+"/**")
        conf['includePath']=list_get_uniq(conf['includePath'])
        conf['environments'] = conan_env


    data['environments'] = conan_env
    print(json.dumps(conan_env, indent=1))


    s=json.dumps(data, indent=1)
    #print(s)

    with open(fullpath, 'w') as f:
        f.write(s)

except Exception as e:
    print("Unable to write the vscode configuration. Did the build process work?")
    print(e)
    print(traceback.format_exc())
    exit(-1)
