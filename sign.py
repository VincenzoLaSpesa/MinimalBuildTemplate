from subprocess import check_output

def run(cmd, echo=True, shell=True, printOutput = True) -> str:
    """ Runs a command, returns the output """    

    if echo:
        print(cmd)
    output = check_output(cmd, shell=shell).decode("utf-8") 
    if printOutput:
      print(output)
    return output

## main

targets=(
    ("ConanWrapper.cmake", "# "),
    ("build.bat", "@rem "),
    ("build.sh", "# ")
)


commit_id=run("git log --format='%cd %H' -n 1", echo=False,printOutput=False)
remote=run("git remote -v", echo=False,printOutput=False).split()[1]
signature=f"Based on {remote} {commit_id}"
print(signature)

for couple in targets:
    with open(couple[0], "a") as file_object:
        print("Signing", couple[0])
        file_object.write("\n"+couple[1]+signature+" \n")    