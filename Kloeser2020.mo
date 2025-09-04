model Kloeser2020
  import Modelica.Math.*;

  // --- Parameters (Table 1 from Kloeser2020) ---
  parameter Real m    = 0.043  "Mass [kg]";
  parameter Real lr   = 0.025  "Rear length [m]";
  parameter Real lf   = 0.025  "Front length [m]";
  parameter Real cm1  = 0.28;
  parameter Real cm2  = 0.05;
  parameter Real cr0  = 0.006;
  parameter Real cr2  = 0.011;
  parameter Real cr3  = 5.0;

  // Constant curvature (circle)
  parameter Real kappa = 1 "Road curvature [1/m] (constant)";

  // --- Inputs ---
  input Real D(min = -1, max = 1)     "Duty cycle of electric motor";
  input Real delta(min = -1, max = 1) "Steering angle";

  // --- Outputs ---
  output Real acc_long "Longitudinal acceleration";
  output Real acc_lat  "Lateral acceleration";

  // --- States ---
  Real s     "Tangential position";
  Real n     "Normal position";
  Real alpha "Heading";
  Real v     "Speed";

  // Auxiliaries
  Real beta;
  Real Fx_d;
  Real ds, dn, dalpha, dv;

equation
  // beta (slip-free approximation, small angle)
  beta = lr/(lr + lf) * delta;

  // Longitudinal force
  Fx_d = (cm1 - cm2*v)*D - cr2*v*v - cr0*tanh(cr3*v);

  der(s)     = v*cos(alpha + beta)/(1 - n*kappa);
  der(n)     = v*sin(alpha + beta);
  der(alpha) = (v/lr)*sin(beta) - kappa*der(s);
  der(v)     = (Fx_d/m)*cos(beta);

  // Outputs
  acc_long = Fx_d/m;
  acc_lat  = v*v/lr*sin(beta) + Fx_d*sin(beta)/m;

initial equation
  s     = 0;
  n     = 0;
  alpha = 0;
  v     = 0;

end Kloeser2020
