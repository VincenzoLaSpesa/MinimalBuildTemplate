""" 
    Adds a comment with the last commit of this repository to all the scripts
"""
from subprocess import check_output
import os
import glob

def run(cmd, echo=True, shell=True, printOutput = True) -> str:
    """ Runs a command, returns the output """    

    if echo:
        print(cmd)
    output = check_output(cmd, shell=shell).decode("utf-8") 
    if printOutput:
      print(output)
    return output

## main

targets=[
    ("fix_vscode_paths.py" , "# ")
]

for path in  glob.glob('*.sh'):
    targets.append([path, "# "])

for path in  glob.glob('*.bat'):
    targets.append([path, "@rem "])

for path in  glob.glob('*.ps1'):
    targets.append([path, "# "])


commit_id=run("git log --format=\"\%cd %H\" -n 1", echo=False,printOutput=False)
remote=run("git remote -v", echo=False,printOutput=False).split()[1]
signature=f"Based on {remote} {commit_id}"
print(signature)

for couple in targets:
    try:
        if os.path.isfile(couple[0]):
            with open(couple[0], "a") as file_object:
                print("Signing", couple[0])
                file_object.write("\n"+couple[1]+signature+" \n")        
    except Exception as e:
        print("Unable to sign", couple[0], e)
