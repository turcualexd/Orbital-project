clear, clc, close all;

n = 40;
%[dv_min, dep_date, fb_date, arr_date] = brute_force_validation(n);
% f = @() brute_force_validation(n);

[dv_min, dep_date, fb_date, arr_date] = brute_force_validation_mex(n);
f = @() brute_force_validation_mex(n);

%t = timeit(f)