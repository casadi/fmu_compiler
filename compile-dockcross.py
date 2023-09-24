import sys
import glob

import zipfile

arg = sys.argv[1]

print(arg)

import subprocess

# -u $(id -u):$(id -g)
subprocess.Popen('docker run --rm -v`pwd`:/local ghcr.io/casadi/ci-doc:latest bash -c "cp -R /usr/include/omc/c/fmi/* /local/omc_fmi"',shell=True).wait()


for f in glob.glob("*.fmu"):
    with zipfile.ZipFile(f, 'r') as zip_ref:
        zip_ref.extractall('unzipped')
        
        subprocess.Popen("./dockcross cmake -Bbuild build-dir -DFMI_INTERFACE_HEADER_FILES_DIRECTORY=`pwd`/omc_fmi -Hunzipped/sources",shell=True)
