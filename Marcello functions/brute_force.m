function [dv_min, dep_date, fb_date, arr_date] = brute_force(T_dep, TOF1, TOF2)

%------------------------Brute-force algorithm-----------------------------
% This function calculate the minimum deltaV for a interplanetary
% trajectory from Mars to Asteroid65 with fly-by on Earth. The function
% uses three time-based DOF: departure date range, time of flight of
% first leg and time of flight of second leg. The output is the calculated
% minimum total cost, computed as the injection cost on first Lambert
% arc, assist cost at pericentre of flyby hyperbola and exit cost from second
% Lambert arc.
%
%--------------------------------------------------------------------------
% 
% INPUT:
% T_dep      [1xN]:  in mjd2000;
% TOF_1      [1xM]:  in mjd2000;\Delta V_i
% TOF_2      [1xK]:  in mjd2000;
%
% OUTPUT:
% dv_min     [1x1]: in km/s;
% dep_date   [1x1]: in mjd2000;
% fb_date    [1x1]: in mjd2000;
% arr_date   [1x1]: in mjd2000;
%
%--------------------------------------------------------------------------
%
%
%
dv_min = 1e10;
wait = waitbar(0, 'Minimum search... (0%)');
for i = 1 : length(T_dep)
   waitbar(i/length(T_dep), wait, sprintf('Minimum search... (%g%%)', i/length(T_dep)* 100));
    
   for j = 1 : length(TOF1)
        
        T_fb  = T_dep(i) + TOF1(j);
        [dv1, ~, V_m] = cost_lambert(T_dep(i), T_fb, 4, 3, 0);
        
        for k = 1 : length(TOF2)
            
            T_arr = T_fb     + TOF2(k);
            [dv2, V_p, ~] = cost_lambert_2(T_fb, T_arr, 3, 65, 0);
            [dv3, rp]     = cost_gravity_assist(T_fb, 3, V_m, V_p);
            
            dvtot = dv1 + dv2 + dv3;

            if (dvtot < dv_min) && rp > (astroConstants(23) + 500)

                dv_min = dvtot;
                dep_date = T_dep(i);
                fb_date =  T_fb;
                arr_date = T_arr;

            end
        end
    end
end

close(wait);
