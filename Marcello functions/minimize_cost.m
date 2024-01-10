function [dv_min, dv1_min, dv2_min, dv3_min,  dep_min, fb_min, arr_min, perc] = minimize_cost(dep_vec, TOF1_vec,TOF2_vec)

dv_min = 1e6;

dep_min = NaN;

fb_min = NaN;

arr_min = NaN;

dv1_min = NaN;

dv2_min = NaN; 

dv3_min = NaN;

perc = NaN;

fun = @(x) total_cost(x);

for i = 1 : length(dep_vec)

    dep_date = dep_vec(i);

    for j = 1 : length(TOF1_vec)

        TOF1 = TOF1_vec(j);

        for k = 1 : length(TOF2_vec)

            TOF2 = TOF2_vec(k);

            x0 = [dep_date; TOF1; TOF2];

            [x, dv] = fminunc(fun, x0);

            [dv1, ~, V_m] = cost_lambert(x(1), x(1) + x(2), 4, 3, 0);
            
            [dv2, V_p, ~] = cost_lambert_2(x(1) + x(2), x(1) + x(2) + x(3), 3, 65, 0 );

            [dv3, rp] = cost_gravity_assist(x(1) + x(2), 3, V_m, V_p);

            DV3 = norm(V_m - V_p);

            if dv < dv_min && rp > astroConstants(23) + 200

                dep_min = x(1);

                fb_min = dep_min + x(2);

                arr_min = fb_min + x(3);

                dv_min = dv;

                dv1_min = dv1; 

                dv2_min = dv2;
                
                dv3_min = dv3;

                perc = dv3_min / DV3;

            end

        end

    end

end

end