clear; close all; clc;

%----------------------DEFINITION OF TIME DOMAIN---------------------------

% earlies depature defined
earl_dep_date   = [2028 01 01 00 00 00];
earl_dep_mjd2000 = date2mjd2000(earl_dep_date);

num             = 40; %number of elements of array of mjd2000 

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

%---------------------------BRUTE FORCE REFINED RUN------------------------

[dv_min, dep_mjd2000, fb_mjd2000, arr_mjd2000] = brute_force(dep_vec, TOF1_vec, TOF2_vec);

fun = @(x) total_cost(x);
x0  = [dep_mjd2000; fb_mjd2000-dep_mjd2000; arr_mjd2000-fb_mjd2000];

[x,dv_min_ref] = fminunc(fun,x0);

%% ---------------------------- FINAL RESULTS -----------------------------

dep = x(1); fb = x(1) + x(2); arr = fb + x(3);
[dv1,VI_HL_1, VF_HL_1] = cost_lambert(dep, fb, 4, 3, 0);
[dv2,VI_HL_2, VF_HL_2] = cost_lambert_2(fb, arr, 3, 65, 0);
[dv3, rp]              = cost_gravity_assist(fb, 3, VF_HL_1, VI_HL_2);

dep_gregorian = mjd20002date(dep);
fb_gregorian = mjd20002date(fb);
arr_gregorian = mjd20002date(arr);

% ---- Heliocentric legs of optimal solution - data retrieved

orbitType = 0;

[kep1,~] = uplanet(dep_mjd2000, 4);
[kep2,mu_s] = uplanet(fb_mjd2000, 3);
[kep3] = ephNEO(arr_mjd2000, 65);

[R1, V1] = kep2car(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),kep1(6), mu_s);
[R2, V2] = kep2car(kep2(1),kep2(2),kep2(3),kep2(4),kep2(5),kep2(6), mu_s);
[R3, V3] = kep2car(kep3(1),kep3(2),kep3(3),kep3(4),kep3(5),kep3(6), mu_s);

TOF1 = (fb_mjd2000 - dep_mjd2000)*24*3600;
TOF2 = (arr_mjd2000 - fb_mjd2000)*24*3600;

[A1,P1,E1,~,VI,VF1,~,THETA1] = lambertMR(R1,R2,TOF1,mu_s,orbitType,0);
[~,~,I1,O1,W1,theta1] = car2kep(R1,VI', mu_s);

[A2,P2,E2,ERROR,VI,VF,TPAR,THETA2] = lambertMR(R2,R3,TOF2,mu_s,orbitType,0);
[~,~,I2,O2,W2,theta2] = car2kep(R2,VI', mu_s);

%-Convert heliocentric keplerian element' units for consistency with report

A1 = A1/astroConstants(2);
A2 = A2/astroConstants(2);

I1 = rad2deg(I1);
I2 = rad2deg(I2);

O1 = rad2deg(O1);
O2 = rad2deg(O2);

W1 = rad2deg(W1);
W2 = rad2deg(W2);

theta1_i = rad2deg(theta1);
theta1_f = wrapTo360(rad2deg(theta1 + THETA1));
theta2_i = rad2deg(theta2);
theta2_f = rad2deg(theta2 + THETA2);
