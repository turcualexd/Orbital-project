%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                       ORBITAL MECHANICS                                 %
%                    Academic year 2023/2024                              %
%                    M.Sc. Space Engineering                              %
%                     Politecnico di Milano                               %
%                                                                         %
%           Assignment 1: Interplanetary Transfer Mission                 %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Group 2319 
% Authors:  - Marcello Pareschi
%           - Daniele Paternoster
%           - Alex Cristian Turcu
%           - Tamim Harun Or
%
% Professor: Camilla Colombo


%% ----------------------DEFINITION OF TIME DOMAIN---------------------------

clear, clc, close all;

% Resonance period calculation
tol = 0.1159;
[i, j, k, T_res] = resonance(tol);

% Synodic periods and resonance period Earth - 1036 Ganymed comparison
tol1 = 0.12;
tol2 = 0.13;
[Tsyn_Earth_Mars, Tsyn_Earth_NEO, Tsyn_Mars_NEO, T_res_Earth_NEO1] = synodic_vs_resonance(tol1);
[~, ~, ~, T_res_Earth_NEO2] = synodic_vs_resonance(tol2);

% Cost plots on restricted 13 years time window
earl_dep_date = [2028 01 01 00 00 00];
late_arr_date = [2041 01 01 00 00 00];
num = 200;
cost_plot(earl_dep_date, late_arr_date)
cost_plot_TOFs(earl_dep_date, late_arr_date, num)

% earlies depature defined
earl_dep_date = [2028 01 01 00 00 00];
earl_dep_mjd2000 = date2mjd2000(earl_dep_date);

num = 40; %number of elements of array of mjd2000 

% Hohmann transfer time Mars - Earth
[kep_mars, ~] = uplanet (earl_dep_mjd2000, 4);
a_mars = kep_mars(1);
[kep_earth, mu_S] = uplanet (earl_dep_mjd2000, 3);
a_earth = kep_earth(1);
at = (a_earth + a_mars) / 2;
TOF_hohmann = pi * sqrt(at^3/mu_S);
TOF_hohmann = TOF_hohmann / 86400; %hohmann tof in days

% flyby date chosen
fb_date = 1.25*1e4; %mjd2000

% TOF_1 defined
TOF1_vec = linspace(0.65,2,num) * TOF_hohmann;

% Departure dates defined
dep_vec = fb_date - TOF1_vec;

% TOF_2 defined
TOF2_vec = linspace(400, 800, num);

%% ---------------------------BRUTE FORCE REFINED RUN------------------------

[dv_min, dep_mjd2000, fb_mjd2000, arr_mjd2000] = brute_force(dep_vec, TOF1_vec, TOF2_vec);

fun = @(x) total_cost(x);
x0  = [dep_mjd2000; fb_mjd2000-dep_mjd2000; arr_mjd2000-fb_mjd2000];

options = optimoptions('fminunc','Display','off');
[x,dv_min_ref] = fminunc(fun,x0, options);

%% ---------------------------- FINAL RESULTS -----------------------------

dep = x(1); fb = x(1) + x(2); arr = fb + x(3);

% Total time of flight
T_earth = 2*pi * sqrt(a_earth^3 / mu_S) / (60^2 * 24);
TOF_tot = (arr - dep) / T_earth;

% Dates in gregorian calendar
dep_gregorian = mjd20002date(dep);
fb_gregorian = mjd20002date(fb);
arr_gregorian = mjd20002date(arr);

% Heliocentric legs of optimal solution - plots
[dvs, kep_arc1_i, kep_arc2_i, dtheta_arc1, dtheta_arc2, rp, ratio, T_SOI] = ...
calculate_transfer(dep, fb, arr);
