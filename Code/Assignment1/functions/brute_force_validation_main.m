clear; close all; clc;

%----------------------DEFINITION OF TIME DOMAIN---------------------------

% earlies depature defined
earl_dep_date   = [2028 01 01 00 00 00];
late_arr_date   = [2028+13 01 01 00 00 00];
earl_dep_mjd2000 = date2mjd2000(earl_dep_date);
late_arr_mjd2000 = date2mjd2000(late_arr_date);

num             = 100; %number of elements of array of mjd2000 

% Departure dates defined
dep_vec = linspace(earl_dep_mjd2000, late_arr_mjd2000, num);
fb_mjd2000 = dep_vec;
TOF1_vec = fb_mjd2000 - dep_vec(1);
TOF2_vec = TOF1_vec;


%% ---------------------------PURE BRUTE FORCE RUN---------------------------

[dv_min, dep_mjd2000, fb_mjd2000, arr_mjd2000] = brute_force(dep_vec, TOF1_vec, TOF2_vec);

%% --------------------------------RESULTS---------------------------------

dep_gregorian = mjd20002date(dep_mjd2000);
fb_gregorian = mjd20002date(fb_mjd2000);
arr_gregorian = mjd20002date(arr_mjd2000);

[dv1,VI_HL_1, VF_HL_1] = cost_lambert(dep_mjd2000, fb_mjd2000, 4, 3, 0);
[dv2,VI_HL_2, VF_HL_2] = cost_lambert_2(fb_mjd2000, arr_mjd2000, 3, 65, 0);
[dv3, rp]              = cost_gravity_assist(fb_mjd2000, 3, VF_HL_1, VI_HL_2);