clear; close all; clc; 

load("dates_for_plots.mat")

%%
dttot = (arr - dep)/365;

dep_date = mjd20002date(dep);

fb_date = mjd20002date(fb);

arr_date = mjd20002date(arr);

%% compute single Deltavs

[dv1, ~, V_m] = cost_lambert(dep, fb, 4, 3, 0);

[dv2, V_p, ~] = cost_lambert_2(fb, arr, 3, 65, 0 );

[dv3, rp] = cost_gravity_assist(fb, 3, V_m, V_p);

dv = dv1 + dv2 + dv3;
%% Plot elliptical arcs
orbitType = 0;

[kep1,~] = uplanet(dep, 4); %Mars param in dep date

[kep2,mu_s] = uplanet(fb, 3); %Earth param in fb date

[kep3] = ephNEO(arr, 65); %Ganymed param in arr date

[R1, V1] = kep2car(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),kep1(6), mu_s); %car Mars dep

[R2, V2] = kep2car(kep2(1),kep2(2),kep2(3),kep2(4),kep2(5),kep2(6), mu_s); %car Earth fb

[R3, V3] = kep2car(kep3(1),kep3(2),kep3(3),kep3(4),kep3(5),kep3(6), mu_s); %car Ganymed arr

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
%% Compute rp of hyperbola
v_m = VF1' - V2;

v_p = VI' - V2;

RE = astroConstants(23);

mu_E = astroConstants(13);

delta = acos(dot(v_m, v_p) / (norm(v_m) * norm(v_p)));

rp = compute_rp(mu_E, norm(v_m), norm(v_p), delta, RE);
%% Plot hyperbola
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
%% time in soi
R = astroConstants(2);

G = astroConstants(1); 

mu_sun = astroConstants(4);

mu_earth = astroConstants(13);

m_sun = mu_sun / G; 

m_earth = mu_earth / G;

r_soi = R * (m_earth / m_sun) ^ (2 / 5);

a_minus = - mu_earth / norm(v_m) ^ 2;

a_plus =  - mu_earth / norm(v_p) ^ 2;

e_minus = 1 + rp .* norm(v_m) .^ 2 ./ mu_earth;

e_plus =  1 + rp .* norm(v_p) .^ 2 ./ mu_earth;

p_minus = rp .* (1 + e_minus);

p_plus = rp .* (1 + e_plus);

theta_minus =  acos(1 ./ e_minus .* (p_minus ./ r_soi - 1));

theta_plus =    acos(1 ./ e_plus .* (p_plus ./ r_soi - 1));

F_minus = 2 * atanh(tan(theta_minus/2)*sqrt((e_minus-1)/(e_minus+1)));

F_plus = 2 * atanh(tan(theta_plus/2)*sqrt((e_plus-1)/(e_plus+1)));

M_minus = - (F_minus - e_minus * sinh(F_minus));

M_plus = - (F_plus - e_plus * sinh(F_plus));

n_minus = sqrt(mu_earth / abs(a_minus) ^ 3);

n_plus = sqrt(mu_earth / abs(a_plus) ^ 3);

dt_minus = M_minus / n_minus;

dt_plus = M_plus / n_plus;

dt = (dt_plus + dt_minus) / 3600; %time in soi in hours
%% hyperbola in the soi
u = cross(v_m, v_p) / norm(cross(v_m, v_p));

D = [0; -1; 0]; %pass in front

delta_minus =  2 * asin(1 ./ e_minus);

beta_minus = pi/2 - delta_minus / 2;

dir_peri = rodrigues(D, u, pi/2 - beta_minus);

r0 = dir_peri * rp;

v_dir = cross(u, dir_peri) / norm(cross(u, dir_peri));

vp1 = sqrt(norm(v_m)^2 + 2*mu_earth/rp);

vp2 = sqrt(norm(v_p)^2 + 2*mu_earth/rp);

v0_bk = - vp1 * v_dir;

v0_fw = vp2 * v_dir;

y0_fw = [r0; v0_fw];

y0_bk = [r0; v0_bk];

tspan_bk = [0, dt_minus];

tspan_fw = [0, dt_plus];

options = odeset('RelTol',1e-13, 'AbsTol',1e-14);

[~,Y_bk] = ode113(@(t, y) ode_2BodyProblem(t, y, mu_earth),tspan_bk,y0_bk,options);

[T,Y_fw] = ode113(@(t, y) ode_2BodyProblem(t, y, mu_earth),tspan_fw,y0_fw,options);

R_bk = Y_bk(:, 1:3);

R_fw = Y_fw(:, 1:3);

RE = astroConstants(23);

Terra_3D(RE)

hold on

grid on

plot3(R_bk(:,1), R_bk(:,2), R_bk(:,3), 'Color', 'r', 'LineWidth',2)

plot3(R_fw(:,1), R_fw(:,2), R_fw(:,3), 'Color','b', 'LineWidth',2)