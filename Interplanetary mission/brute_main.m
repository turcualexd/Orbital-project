clear; close all; clc;

earl_dep_date   = [2028 01 01 00 00 00];

num             = 10; %number of elements of array of mjd2000 

earl_dep_mjd2000 = date2mjd2000(earl_dep_date);

[kep_mars, ~] = uplanet (earl_dep_mjd2000, 4);

a_mars = kep_mars(1);

[kep_earth, ksun] = uplanet (earl_dep_mjd2000, 3);

a_earth = kep_earth(1);

at = (a_earth + a_mars) / 2;

TOF_hohmann = pi * sqrt(at^3/ksun);

TOF_hohmann = TOF_hohmann / 86400; %hohmann tof in days

fb_date = 1.25*1e4; %mjd2000

TOF1_vec = linspace(0.65,2,40) * TOF_hohmann;

dep_vec = fb_date - TOF1_vec;
%dep_vec = linspace(1.235*1e4-2*TOF_hohmann, 1.255*1e4 + 0.65*TOF_hohmann, 10);
%TOF2_vec = linspace(300, 900, 10);
TOF2_vec = linspace(400, 800, 40);
[dv_min, dep_mjd2000, fb_mjd2000, arr_mjd2000] = brute_force(dep_vec, TOF1_vec, TOF2_vec);

%dttot = (arr_date - dep_date)/365;

fun = @(x) total_cost(x);
x0  = [dep_mjd2000; fb_mjd2000-dep_mjd2000; arr_mjd2000-fb_mjd2000];

[x,dv_min_ref] = fminunc(fun,x0);