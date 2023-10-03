model CSTR
  // Parameters
  parameter Real V = 1.0 "Volume of the reactor (m^3)";
  parameter Real k = 0.5 "Reaction rate constant (m^3/mol/s)";

  // Inputs
  input Real q_in "Inlet flow rate (m^3/s)";
  input Real C_A_in "Inlet concentration of A (mol/m^3)";
  input Real C_B_in "Inlet concentration of B (mol/m^3)";

  // Variables
  Real C_A(start = 0.5) "Concentration of A in the reactor (mol/m^3)";
  Real C_B(start = 0.5) "Concentration of B in the reactor (mol/m^3)";

equation
  // Material balances for the reactor
  V*der(C_A) = q_in*(C_A_in - C_A) - V*k*C_A*C_B;
  V*der(C_B) = q_in*(C_B_in - C_B) + V*k*C_A*C_B;

end CSTR;
