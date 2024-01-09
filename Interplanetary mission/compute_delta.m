function rp = compute_delta(mu, v_minus, v_plus, delta, R_plan)


e_m = @(rp) 1 + rp .* v_minus .^ 2 ./ mu;

delta_m = @(rp) 2 * asin(1 ./ e_m(rp));

e_p = @(rp) 1 + rp .* v_plus .^ 2 ./ mu;

delta_p = @(rp) 2 * asin(1 ./ e_p(rp));

Delta = @(rp) delta_m(rp)/2 + delta_p(rp)/2-delta;

fun = @(rp) Delta(rp) ;

% options.Display = 'off';
% options = optimoptions('fsolve','Algorithm','levenberg-marquardt', 'Display', 'off');

% rp = fsolve(fun, R_plan, options);
options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','off');
rp = lsqnonlin(fun, R_plan, 0, 1e10, options);

return