function [dv_min, dep_min, fb_min, arr_min] = monte_optim(range, N, min_dep, max_arr)

dv_min = 1e10;

fun = @(x) Cost_Maneuver(x);

for i = 1 : N

    dep = casual_number(range(1), range(2));

    fb = casual_number(dep, dep*1.3);

    arr = casual_number(fb, fb*1.3);

    x0 = [dep; fb; arr];

    [x, dv] = fminunc(fun, x0);

    if (dv < dv_min) && (x(2) > x(1)) && (x(3) > x(2)) && (x(1) > min_dep) && (x(3) < max_arr)

        dv_min = dv;

        dep_min = x(1);

        fb_min = x(2);

        arr_min = x(3);

    end

end

end