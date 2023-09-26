import sys

from OMPython import OMCSessionZMQ
omc = OMCSessionZMQ()

if omc.loadFile(sys.argv[1]).startswith('false'):
  raise Exception('Modelica compilation failed: {}'.format(omc.sendExpression('getErrorString()')))
omc.sendExpression('setDebugFlags("-disableDirectionalDerivatives")')
omc.sendExpression('setCommandLineOptions("-d=initialization")')
fmu_file = omc.sendExpression('translateModelFMU(' + sys.argv[1].split(".")[0]+')')
flag = omc.sendExpression('getErrorString()')

print(fmu_file)
if not fmu_file.endswith('.fmu'): raise Exception('FMU generation failed: {}'.format(flag))
print("translateModelFMU warnings:\n{}".format(flag))

