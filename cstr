model CSTR
  // Parameters
  parameter Real V(unit="m3") = 1.0 "Volume of the reactor";
  parameter Real k(unit="m3/mol/s") = 0.5 "Reaction rate constant";

  // Inputs
  input Real q_in(unit="m3/s") "Inlet flow rate";
  input Real C_A_in(unit="mol/m3") "Inlet concentration of A";
  input Real C_B_in(unit="mol/m3") "Inlet concentration of B";

  // Variables
  Real C_A(unit="mol/m3", start = 0.5) "Concentration of A in the reactor";
  Real C_B(unit="mol/m3", start = 0.5) "Concentration of B in the reactor";

equation
  // Material balances for the reactor
  V*der(C_A) = q_in*(C_A_in - C_A) - V*k*C_A*C_B;
  V*der(C_B) = q_in*(C_B_in - C_B) + V*k*C_A*C_B;

end CSTR;
