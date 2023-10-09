model vdp_outputs
    // State start values
    parameter Real x1_0 = 0;
    parameter Real x2_0 = 1;

    // The states
    Real x1(start = x1_0, fixed = true);
    Real x2(start = x2_0, fixed = true);

    // The control signal
    input Real u;

    // Outputs
    output String where_are_we = if x1^2+x2^2 < 0.1 then "at origin" else "not at origin";
    output Integer x1_crude = round(x1);
    output Real combo = x1^2+x2^2;
 equation
    der(x1) = (1 - x2^2) * x1 - x2 + u;
    der(x2) = x1;
end vdp;
