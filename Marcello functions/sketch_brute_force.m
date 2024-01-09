function [dv_min, dep, fb, arr] = sketch_brute_force(range_dep, range_fb, range_arr)

dv_min = 1e10;

for i = 1 : length(range_dep)

    for j = i : length(range_fb)

        for k = j : length(range_arr)

            if (range_dep(i) < range_fb(j)) && (range_fb(j) < range_arr(k)) && (range_dep(i) < range_arr(k))

                [dv1, ~, V_m] = cost_lambert(range_dep(i), range_fb(j), 4, 3, 0);

                [dv2, V_p, ~] = cost_lambert_2(range_fb(j), range_arr(k), 3, 65, 0 );

                dv3 = norm(V_m - V_p);

                dvtot = dv1 + dv2 + dv3;

                if dvtot < dv_min

                    dv_min = dvtot;

                    dep = range_dep(i);

                    fb = range_fb(j);

                    arr = range_arr(k);

                end

            end

        end

    end

end