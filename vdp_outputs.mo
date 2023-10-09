model vdp_outputs
    Real x1(start = 0, fixed = true);
    Real x2(start = 1, fixed = true);
    input Real u;
    parameter String msg_in = "unset";
    output String msg_out = msg_in;
 equation
    der(x1) = (1 - x2^2) * x1 - x2 + u;
    der(x2) = x1;
end vdp;
