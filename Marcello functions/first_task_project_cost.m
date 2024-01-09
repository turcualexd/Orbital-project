clear; close all; clc; 

date_dep = [2028, 1, 1, 0, 0, 0];

date_arr = [2058, 1, 1, 0, 0, 0];

[dv, dep, TOF_1, TOF_2] = minimize_cost(date_dep, date_arr);

%%

dep_date = mjd20002date(dep);

arr_date = mjd20002date(dep+TOF_1+TOF_2);

%%