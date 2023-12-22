function dv = total_cost(x)

dep = x(1);

TOF1 = x(2);

TOF2 = x(3);

[dv1, ~, V_m] = cost_lambert(dep, dep + TOF1, 4, 3, 0);

[dv2, V_p, ~] = cost_lambert_2(dep + TOF1, dep + TOF1 + TOF2, 3, 65, 0 );

dv3 = norm(V_m - V_p);

dv = dv1 + dv2 + dv3;

end