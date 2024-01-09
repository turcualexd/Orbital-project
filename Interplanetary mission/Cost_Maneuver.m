function dv = Cost_Maneuver(x)

mjd2000_dep = x(1);

TOF1 = x(2);

TOF2 = x(3);

[dv1, ~, V_m] = cost_lambert(mjd2000_dep, mjd2000_dep + TOF1, 4, 3, 0);

[dv2, ~, V_p] = cost_lambert_2(mjd2000_dep + TOF1, mjd2000_dep + TOF1 + TOF2, 3, 65, 0 );

dv3 = cost_gravity_assist(mjd2000_dep + TOF1, 3, V_m, V_p);

dv = dv1 + dv2 + dv3;

