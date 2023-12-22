function [dv_min, dep_min, fb_min, arr_min] = minimize_cost(dep_vec, TOF1_vec,TOF2_vec)

dv_min = 1e6;

dep_min = NaN;

fb_min = NaN;

arr_min = NaN;

fun = @(x) total_cost(x);

for i = 1 : length(dep_vec)

    dep_date = dep_vec(i);

    for j = 1 : length(TOF1_vec)

        TOF1 = TOF1_vec(j);

        for k = 1 : length(TOF2_vec)

            TOF2 = TOF2_vec(k);

            x0 = [dep_date; TOF1; TOF2];

            [x, dv] = fminunc(fun, x0);

            if dv < dv_min

                dep_min = x(1);

                fb_min = dep_min + x(2);

                arr_min = fb_min + x(3);

                dv_min = dv;

            end

        end

    end

end

end