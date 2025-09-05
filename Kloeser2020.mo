model Kloeser2020 "Bicycle model of a model race car, from Kloeser2020 paper"
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
  Real kappa "Road curvature [1/m] (constant)";

  // --- Inputs ---
  input Real D_der(min = -20.0, max = 20.0)     "Rate of duty cycle";
  input Real delta_der(min = -4.0, max = 4.0) "Rate of steering angle";

  Real D(min = -1, max = 1)         "Duty cycle of electric motor";
  Real delta(min = -0.8, max = 0.8) "Steering angle";
  
  // --- Outputs ---
  output Real acc_long "Longitudinal acceleration";
  output Real acc_lat  "Lateral acceleration";
  
  output Real p_x "car x coordinate";
  output Real p_y "car y coordinate";

  output Real c_x "Center line x coordinate";
  output Real c_y "Center line y coordinate";
  output Real e_n_x "Central path normal vector, projection on world x";
  output Real e_n_y "Central path normal vector, projection on world y";

  // --- States ---
  Real s     "Tangential position";
  Real n     "Normal position";
  Real alpha "Heading";
  Real v     "Speed";

  // Auxiliaries
  Real beta;
  Real Fx_d;
  Real ds, dn, dalpha, dv;
  
  Real s_mod "s wrapped to [0, 4*pi)";

  // ---- Local functions ----
  function logsumexp2
    "Numerically stable LSE for two arguments with temperature alpha"
    input Real a;
    input Real b;
    input Real alpha=0.1;
    output Real y;
  protected 
    Real m;
  algorithm 
    m := if a > b then a else b;
    y := m + alpha*Modelica.Math.log(
            Modelica.Math.exp((a - m)/alpha) 
          + Modelica.Math.exp((b - m)/alpha));
  end logsumexp2;

  function clip1
    "Smooth min(x,1) via -logsumexp([-1,-x]) with temperature alpha"
    input Real x;
    input Real alpha=0.1;
    output Real y;
  algorithm 
    y := -logsumexp2(-1.0, -x, alpha);
  end clip1;
  
equation
  // beta (slip-free approximation, small angle)
  beta = lr/(lr + lf) * delta;

  // Longitudinal force
  Fx_d = (cm1 - cm2*v)*D - cr2*v*v - cr0*tanh(cr3*v);
  
  kappa = (-clip1(-clip1(-10*sin(s), 0.1), 0.1) + 1.0)/2.0;

  // Dynamics
  ds     = v*cos(alpha + beta)/(1 - n*kappa);
  dn     = v*sin(alpha + beta);
  dalpha = (v/lr)*sin(beta) - kappa*ds;
  dv     = (Fx_d/m)*cos(beta);

  der(s)     = ds;
  der(n)     = dn;
  der(alpha) = dalpha;
  der(v)     = dv;

  der(D)     = D_der;
  der(delta) = delta_der;

  // Outputs
  acc_long = Fx_d/m;
  acc_lat  = v*v/lr*sin(beta) + Fx_d*sin(beta)/m;

  // s modulo 4π
  s_mod = s; //mod(s, 4*Modelica.Constants.pi);

  // Piecewise definition of gamma and normal
  if s_mod < Modelica.Constants.pi then
    c_x   = s_mod;
    c_y   = 0;
    e_n_x = 0;
    e_n_y = 1;
  elseif s_mod < 2*Modelica.Constants.pi then
    c_x   = sin(s - Modelica.Constants.pi) + Modelica.Constants.pi;
    c_y   = 1 - cos(s - Modelica.Constants.pi);
    e_n_x = -sin(s - Modelica.Constants.pi);
    e_n_y =  cos(s - Modelica.Constants.pi);
  elseif s_mod < 3*Modelica.Constants.pi then
    c_x   = 3*Modelica.Constants.pi - s_mod;
    c_y   = 2;
    e_n_x = 0;
    e_n_y = -1;
  else
    c_x   = -sin(s - 3*Modelica.Constants.pi);
    c_y   =  1 + cos(s - 3*Modelica.Constants.pi);
    e_n_x =  sin(s - 3*Modelica.Constants.pi);
    e_n_y = -cos(s - 3*Modelica.Constants.pi);
  end if;
  
  p_x = c_x+n*e_n_x;
  p_y = c_y+n*e_n_y;
end Kloeser2020;
