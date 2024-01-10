clear; close all; clc;

%----------------------DEFINITION OF TIME DOMAIN---------------------------

% earlies depature defined
earl_dep_date   = [2028 01 01 00 00 00];
earl_dep_mjd2000 = date2mjd2000(earl_dep_date);

num             = 100; %number of elements of array of mjd2000 

% Hohmann trasnfer time Mars - Earth
[kep_mars, ~] = uplanet (earl_dep_mjd2000, 4);
a_mars = kep_mars(1);
[kep_earth, ksun] = uplanet (earl_dep_mjd2000, 3);
a_earth = kep_earth(1);
at = (a_earth + a_mars) / 2;
TOF_hohmann = pi * sqrt(at^3/ksun);
TOF_hohmann = TOF_hohmann / 86400; %hohmann tof in days

% flyby date chosen
fb_date = 1.25*1e4; %mjd2000

% TOF_1 defined
TOF1_vec = linspace(0.65,2,num) * TOF_hohmann;

% Departure dates defined
dep_vec = fb_date - TOF1_vec;

% TOF_2 defined
TOF2_vec = linspace(400, 800, num);

%% ---------------------------PURE BRUTE FORCE RUN---------------------------

[dv_min, dep_mjd2000, fb_mjd2000, arr_mjd2000] = brute_force(dep_vec, TOF1_vec, TOF2_vec);

%% --------------------------------RESULTS---------------------------------

dep_gregorian = mjd20002date(dep_mjd2000);
fb_gregorian = mjd20002date(fb_mjd2000);
arr_gregorian = mjd20002date(arr_mjd2000);

[dv1,VI_HL_1, VF_HL_1] = cost_lambert(dep_mjd2000, fb_mjd2000, 4, 3, 0);
[dv2,VI_HL_2, VF_HL_2] = cost_lambert_2(fb_mjd2000, arr_mjd2000, 3, 65, 0);
[dv3, rp]              = cost_gravity_assist(fb_mjd2000, 3, VF_HL_1, VI_HL_2);




