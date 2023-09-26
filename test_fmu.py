from casadi import *
import zipfile
import glob
import shutil

for f in glob.glob("*.fmu"):
    print(f)
    with zipfile.ZipFile(f, 'r') as zip_ref: zip_ref.extractall(f+".unzipped")

    dae = DaeBuilder('test', f+".unzipped")
    dae.disp(True)
    
    shutil.rmtree(f+".unzipped")
