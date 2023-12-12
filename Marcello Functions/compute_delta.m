function rp = compute_delta(mu, v_minus, v_plus, delta, R_plan)


e_m = @(rp) 1 + rp .* v_minus .^ 2 ./ mu;

delta_m = @(rp) 2 * asin(1 ./ e_m(rp));

e_p = @(rp) 1 + rp .* v_plus .^ 2 ./ mu;

delta_p = @(rp) 2 * asin(1 ./ e_p(rp));

Delta = @(rp) delta_m(rp)/2 + delta_p(rp)/2-delta;

fun = @(rp) Delta(rp) ;

options.Display = 'off';

rp = fsolve(fun, R_plan, options);

return







