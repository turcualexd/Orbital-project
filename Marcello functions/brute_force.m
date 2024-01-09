function [dv_min, dep, fb, arr] = brute_force(range)

dv_min = 1e10;

for i = 1 : length(range)

    for j = i : length(range)

        for k = j : length(range)

            [dv1, ~, V_m] = cost_lambert(range(i), range(j), 4, 3, 0);

            [dv2, V_p, ~] = cost_lambert_2(range(j), range(k), 3, 65, 0 );

            dv3 = norm(V_m - V_p);

            dvtot = dv1 + dv2 + dv3;

            if dvtot < dv_min

                dv_min = dvtot;

                dep = range(i);

                fb = range(j);

                arr = range(k);

            end

        end

    end

end