model vdp_outputs
    Real x1(start = 0, fixed = true);
    Real x2(start = 1, fixed = true);
    input Real u;
    Parameter String orign_msg = "at origin";
    Parameter String not_orign_msg = "in the woods";
    output String where_are_we;
    output Integer x1_crude = round(x1);
    output Real combo = x1^2+x2^2;
 equation
    der(x1) = (1 - x2^2) * x1 - x2 + u;
    der(x2) = x1;
    where_are_we = if x1^2+x2^2 < 0.1 then origin_msg else not_origin_msg;
end vdp;
