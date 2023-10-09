model vdp_outputs2
    Real x1(start = 0, fixed = true);
    Real x2(start = 1, fixed = true);
    input Real u(min = -1, max = 1);
    parameter String msg1 = "hello";
    output String greeting = hello+" "+msg;
equation
    der(x1) = (1 - x2^2) * x1 - x2 + u;
    der(x2) = x1;
end vdp_outputs2;
