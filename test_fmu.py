from casadi import *
import zipfile
import glob
import shutil
import os

for f in glob.glob("*.fmu"):
    print(f)
    with zipfile.ZipFile(f, 'r') as zip_ref: zip_ref.extractall(f+".unzipped")

    dae = DaeBuilder('test', os.path.abspath(f+".unzipped"))
    dae.disp(True)
    
    print("provides_directional_derivative", dae.provides_directional_derivative())
    
    ff = dae.create('f', ['x', 'u'], ['ode'])
    
    shutil.rmtree(f+".unzipped")
