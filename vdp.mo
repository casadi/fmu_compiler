model vdp
    // State start values
    parameter Real x1_0 = 0;
    parameter Real x2_0 = 1;

    // The states
    Real x1(start = x1_0, fixed = true);
    Real x2(start = x2_0, fixed = true);

    // The control signal
    input Real u;

 equation
    der(x1) = (1 - x2^2) * x1 - x2 + u;
    der(x2) = x1;
end vdp;
