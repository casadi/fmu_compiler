model vdp_outputs2
    Real x1(start = 0, fixed = true);
    Real x2(start = 1, fixed = true);
    input Real u;
    parameter String msg1 = "hello";
    parameter String msg2 = "world";
    output String out = msg1+" "+msg2;
    output Integer x1_crude = integer(x1);
    output Real combo = x1^2 + x2^2;
equation
    der(x1) = (1 - x2^2) * x1 - x2 + u;
    der(x2) = x1;
end vdp_outputs2;
