import sys
import glob
import os
import zipfile
import shutil

for f in glob.glob("*.mo"):
    import sys

    from OMPython import OMCSessionZMQ
    omc = OMCSessionZMQ()

    if omc.loadFile(f).startswith('false'):
      raise Exception('Modelica compilation failed: {}'.format(omc.sendExpression('getErrorString()')))
    omc.sendExpression('setDebugFlags("-disableDirectionalDerivatives")')
    omc.sendExpression('setCommandLineOptions("-d=initialization")')
    fmu_file = omc.sendExpression('translateModelFMU(' + f.split(".")[0]+')')
    flag = omc.sendExpression('getErrorString()')

    if not fmu_file.endswith('.fmu'): raise Exception('FMU generation failed: {}'.format(flag))
    print("translateModelFMU warnings:\n{}".format(flag))
