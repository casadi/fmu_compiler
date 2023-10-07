model bvsm "A BVSM semi-batch reactor"
  // State variables
  Real VR(unit="L", start = 2370., fixed = true) "Reactor volume";
  Real nA(unit="mol", start = 2.2, fixed = true) "Reactant, A";
  Real nB(unit="mol", start = 0., fixed = true) "Base, B";
  Real nC(unit="mol", start = 0., fixed = true)
    "Mono-halogenated intermediate, C";
  Real nD(unit="mol", start = 0., fixed = true) "Final product, D";
  // Controls
  input Real Qf(unit = "L/min", start = 0) "Volumetric flowrate of base";
  // Known parameters
  parameter Real cBf(unit = "mol/L") = 0.00721 "Base feed concentration";
  // Estimated parameters are formulated as controls
  input Real k1(unit = "L/min/mol", start = 1000, min = 500, max = 50000)
    "Reaction rate constant, A + B -> C + B.HX";
  input Real k2(unit = "L/min/mol", start = 1000, min = 500, max = 50000)
    "Reaction rate constant, C + B -> D + B.HX";
  // Measured output
  output Real lc(start = 0) = 1 / (1 + 2*nD / max(nC, 1e-6))
    "LC measurement model";
equation
  // Material balances for the reactor
  der(VR) = Qf;
  der(nA) = -k1 * nA * nB / VR;
  der(nB) = Qf * cBf - nB * (k1 * nA + k2 * nC) / VR;
  der(nC) = nB * (k1 * nA - k2 * nC) / VR;
  der(nD) = k2 * nC * nB / VR;  
end bvsm;
