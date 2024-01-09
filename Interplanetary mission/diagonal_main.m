clear; close all; clc;

% date_dep = [2028, 1, 1, 0, 0, 0];
% 
% date_arr = [2058, 1, 1, 0, 0, 0];
% 
% range = [date2mjd2000(date_dep), date2mjd2000(date_arr)];

range = [1.0226e+04, 1.0226e+04+13*365];

range = linspace(range(1), range(2), 100);

%[dv_min, dep, fb, arr] = brute_force(range);

[dv_min, dep, fb, arr] = diagonal_search(range);

dep_date = mjd20002date(dep);

fb_date = mjd20002date(fb);

arr_date = mjd20002date(arr);

