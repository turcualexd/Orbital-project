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

%dep_vec = linspace(earl_dep_mjd2000, late_dep_mjd2000);

TOF1_vec = linspace(0.65,2,10) * TOF_hohmann;

dep_vec = fb_date - TOF1_vec;

TOF2_vec = linspace(300, 900, (900-300)/60);


[dv_min, dv1_min, dv2_min, dv3_min,  dep, fb, arr, perc] = minimize_cost(dep_vec, TOF1_vec,TOF2_vec);

dttot = (arr - dep)/365;

dep_date = mjd20002date(dep);

fb_date = mjd20002date(fb);

arr_date = mjd20002date(arr);


%%

orbitType = 0;

[kep1,~] = uplanet(dep, 4);

[kep2,mu_s] = uplanet(fb, 3);

[kep3] = ephNEO(arr, 65);

[R1, V1] = kep2car(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),kep1(6), mu_s);

[R2, V2] = kep2car(kep2(1),kep2(2),kep2(3),kep2(4),kep2(5),kep2(6), mu_s);

[R3, V3] = kep2car(kep3(1),kep3(2),kep3(3),kep3(4),kep3(5),kep3(6), mu_s);

TOF1 = (fb - dep)*24*3600;

TOF2 = (arr - fb)*24*3600;

[A1,P1,E1,~,VI,VF1,~,THETA1] = lambertMR(R1,R2,TOF1,mu_s,orbitType,0);

[~,~,I1,O1,W1,theta1] = car2kep(R1,VI', mu_s);

[A2,P2,E2,ERROR,VI,VF,TPAR,THETA2] = lambertMR(R2,R3,TOF2,mu_s,orbitType,0);

[~,~,I2,O2,W2,theta2] = car2kep(R2,VI', mu_s);

dth = pi / 50;

figure

hold on

grid minor

plotorbit_dotted(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),kep1(6), kep1(6)+2*pi, dth, mu_s, 'r')

plotorbit_dotted(kep2(1),kep2(2),kep2(3),kep2(4),kep2(5),kep2(6), kep2(6)+2*pi, dth, mu_s, 'b')

plotorbit_dotted(kep3(1),kep3(2),kep3(3),kep3(4),kep3(5),kep3(6), kep3(6)+2*pi, dth, mu_s, 'm')

plotorbit(A1,E1,I1,O1,W1,theta1, theta1+THETA1, dth, mu_s, 'g')

plotorbit(A2,E2,I2,O2,W2,theta2, theta2+THETA2, dth, mu_s, 'k')
%% time in the sphere of influence

v_m = VF1' - V2;

v_p = VI' - V2;

RE = astroConstants(23);

mu_E = astroConstants(13);

delta = acos(dot(v_m, v_p) / (norm(v_m) * norm(v_p)));

rp = compute_rp(mu_E, norm(v_m), norm(v_p), delta, RE);

%% plot hyperbola

v_mn = norm(v_m);

v_pn = norm(v_p);

vp1 = sqrt(v_mn^2 + 2*mu_E/rp);

vp2 = sqrt(v_pn^2 + 2*mu_E/rp);

u = cross(VF1', VI');

u = u / norm(u);

D = [0; 1; 0]; %pass in front

e_minus = 1 + rp .* norm(v_m) .^ 2 ./ mu_E;

delta_minus =  2 * asin(1 ./ e_minus);

beta_minus = pi/2 - delta_minus / 2;

dir_peri = rodrigues(D, u, pi/2 - beta_minus);

r0 = dir_peri * rp;

v_dir = cross(u, dir_peri)/ norm(cross(u, dir_peri));

v0_bk = - vp1 * v_dir;

v0_fw = vp2 * v_dir;

tspan = [0, 7 * 1e3]; %s

y0_fw = [r0; v0_fw];

y0_bk = [r0; v0_bk];

options = odeset('RelTol',1e-13, 'AbsTol',1e-14);

[~,Y_bk] = ode113(@(t, y) ode_2BodyProblem(t, y, mu_E),tspan,y0_bk,options);

[T,Y_fw] = ode113(@(t, y) ode_2BodyProblem(t, y, mu_E),tspan,y0_fw,options);

R_bk = Y_bk(:, 1:3);

R_fw = Y_fw(:, 1:3);

Terra_3D(RE)

hold on

grid on

plot3(R_bk(:,1), R_bk(:,2), R_bk(:,3), 'Color', 'r', 'LineWidth',2)

plot3(R_fw(:,1), R_fw(:,2), R_fw(:,3), 'Color','b', 'LineWidth',2)
