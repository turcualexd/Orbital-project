function dv = total_cost(x)

%------------------------Total cost function-------------------------------
%
% This function calculates the cost of the overall mission, given the
% vector x = [dep_date; TOF1; TOF2] [mjd2000].  
%
%--------------------------------------------------------------------------
% 
% INPUT:
% x              [3x1] in mjd2000
%
% OUTPUT:
% dv             [1]: in km/s;
%
%--------------------------------------------------------------------------
%
% AUTHORs: Marcello Pareschi
%
%--------------------------------------------------------------------------

dep = x(1);
TOF1 = x(2);
TOF2 = x(3);

[dv1, ~, V_m] = cost_lambert(dep, dep + TOF1, 4, 3, 0);
[dv2, V_p, ~] = cost_lambert_2(dep + TOF1, dep + TOF1 + TOF2, 3, 65, 0 );
[dv3, ~]      = cost_gravity_assist(dep + TOF1, 3, V_m, V_p);

dv = dv1 + dv2 + dv3;



end