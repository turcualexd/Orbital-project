clear, clc, close all;

%% Initial data

load("dates_for_plots.mat", "dep", "fb", "arr")

[kep_Mars_dep, mu_S] = uplanet(dep, 4);
kep_Earth_fb = uplanet(fb, 3);
kep_NEO_arr = ephNEO(arr, 65);

[R_Mars_dep, V_Mars_dep] = kep2car(kep_Mars_dep(1),kep_Mars_dep(2),kep_Mars_dep(3),kep_Mars_dep(4),kep_Mars_dep(5),kep_Mars_dep(6), mu_S);
[R_Earth_fb, V_Earth_fb] = kep2car(kep_Earth_fb(1),kep_Earth_fb(2),kep_Earth_fb(3),kep_Earth_fb(4),kep_Earth_fb(5),kep_Earth_fb(6), mu_S);
[R_NEO_arr, V_NEO_arr] = kep2car(kep_NEO_arr(1),kep_NEO_arr(2),kep_NEO_arr(3),kep_NEO_arr(4),kep_NEO_arr(5),kep_NEO_arr(6), mu_S);

T_days = @(a) 2*pi * sqrt(a^3 / mu_S) / (60^2 * 24);
T_Earth = T_days(kep_Earth_fb(1));

dep_date = mjd20002date(dep);
fb_date = mjd20002date(fb);
arr_date = mjd20002date(arr);

%% Compute dvs and TOFs

[dv1, ~, V_m] = cost_lambert(dep, fb, 4, 3, 0);
[dv2, V_p, ~] = cost_lambert_2(fb, arr, 3, 65, 0);
[dv3, ~] = cost_gravity_assist(fb, 3, V_m, V_p);
dv = dv1 + dv2 + dv3;

TOF1 = (fb - dep) * 60^2 * 24;
TOF2 = (arr - fb) * 60^2 * 24;
TOF_tot_years = (arr - dep) / T_Earth;

%% Calculate elliptical arcs

[~,~,~,~,vi_arc1,vf_arc1,~,dtheta_arc1] = lambertMR(R_Mars_dep,R_Earth_fb,TOF1,mu_S,0,0);
[a_arc1,e_arc1,i_arc1,Om_arc1,om_arc1,thetai_arc1] = car2kep(R_Mars_dep,vi_arc1',mu_S);

[~,~,~,~,vi_arc2,vf_arc2,~,dtheta_arc2] = lambertMR(R_Earth_fb,R_NEO_arr,TOF2,mu_S,0,0);
[a_arc2,e_arc2,i_arc2,Om_arc2,om_arc2,thetai_arc2] = car2kep(R_Earth_fb,vi_arc2', mu_S);

%% Plot Solar system

dth = pi / 100;
figure
Sun_3D(70)
Mars_3D(R_Mars_dep, 4000)
Terra_3D(R_Earth_fb, 4000)
NEO_3D(R_NEO_arr, 0.5e6)
plotorbit_dotted(kep_Mars_dep(1),kep_Mars_dep(2),kep_Mars_dep(3),kep_Mars_dep(4),kep_Mars_dep(5),0,2*pi,dth,mu_S,"#A2142F")
plotorbit_dotted(kep_Earth_fb(1),kep_Earth_fb(2),kep_Earth_fb(3),kep_Earth_fb(4),kep_Earth_fb(5),0,2*pi,dth,mu_S,'g')
plotorbit_dotted(kep_NEO_arr(1),kep_NEO_arr(2),kep_NEO_arr(3),kep_NEO_arr(4),kep_NEO_arr(5),0,2*pi,dth,mu_S,"m")
plotorbit(a_arc1,e_arc1,i_arc1,Om_arc1,om_arc1,thetai_arc1,thetai_arc1+dtheta_arc1,dth,mu_S,'b')
plotorbit(a_arc2,e_arc2,i_arc2,Om_arc2,om_arc2,thetai_arc2,thetai_arc2+dtheta_arc2,dth,mu_S,'r')
legend('', '', '', '', 'Orbit of Mars', 'Orbit of Earth', 'Orbit of 1036 Ganymed', '1st Lambert arc', '2nd Lambert arc')


%% Compute rp of hyperbola

v_m = vf_arc1' - V_Earth_fb;
v_p = vi_arc2' - V_Earth_fb;
v_mn = norm(v_m);
v_pn = norm(v_p);

R_E = astroConstants(23);
mu_E = astroConstants(13);

a_m = -mu_E / v_mn^2;
a_p = -mu_E / v_pn^2;

delta = acos(dot(v_m, v_p) / (norm(v_m) * norm(v_p)));
rp = compute_rp(mu_E, norm(v_m), norm(v_p), delta, R_E);

e_m = 1 + rp * v_mn^2 / mu_E;
delta_m = 2 * asin(1 / e_m);

e_p = 1 + rp * v_pn^2 / mu_E;
delta_p = 2 * asin(1 / e_p);

u = cross(v_m, v_p);  % direction normal to plane
u = u / norm(u);

n = 1000;

theta_inf_m = acos(-1 / e_m);
lim_m = theta_inf_m - 0.3;
theta_m = linspace(-lim_m, 0, n);
r_mn = a_m * (1 - e_m^2) ./ (1 + e_m * cos(theta_m));
r_per_m = r_mn .* [cos(theta_m); sin(theta_m); zeros(1,n)];

theta_inf_p = acos(-1 / e_p);
lim_p = theta_inf_p - 0.3;
theta_p = linspace(0, lim_p, n);
r_pn = a_p * (1 - e_p^2) ./ (1 + e_p * cos(theta_p));
r_per_p = r_pn .* [cos(theta_p); sin(theta_p); zeros(1,n)];

% figure
% hold on
% axis equal
% plot(r_per_m(1,:), r_per_m(2,:))
% plot(r_per_p(1,:), r_per_p(2,:))

beta_m = (pi - delta_m) / 2;
v_m_unit = v_m / norm(v_m);
v_p_unit = v_p / norm(v_p);
xp = rodrigues(v_m_unit,u,-beta_m);
yp = cross(u, xp);
R = [xp yp u]; % Rotation from perifocal to inertial
R_N_m = R * r_per_m;
R_N_p = R * r_per_p;

% asymptots
C_N_m = -R * [a_m*e_m; 0; 0];
C_N_p = -R * [a_p*e_p; 0; 0];

%% Plot hyperbola

Terra_3D_original
plot3(R_N_m(1,:), R_N_m(2,:), R_N_m(3,:), 'LineWidth', 1.5)
plot3(R_N_p(1,:), R_N_p(2,:), R_N_p(3,:), 'LineWidth', 1.5)
plot3(xp(1) * [-3 2] * 1e4, xp(2) * [-3 2] * 1e4, xp(3) * [-3 2] * 1e4, 'k--')
plot3(C_N_m(1) + v_m_unit(1) * [-5 0] * 1e4, C_N_m(2) + v_m_unit(2) * [-5 0] * 1e4, C_N_m(3) + v_m_unit(3) * [-5 0] * 1e4, 'b--')
plot3(C_N_p(1) + v_p_unit(1) * [0 5] * 1e4, C_N_p(2) + v_p_unit(2) * [0 5] * 1e4, C_N_p(3) + v_p_unit(3) * [0 5] * 1e4, 'r--')
legend('', 'Incoming hyperbola', 'Outcoming hyperbola', 'Apse line', 'Asymptote for incoming hyperbola', 'Asymptote for outcoming hyperbola')


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

e_m = 1 + rp .* norm(v_m) .^ 2 ./ mu_earth;
e_plus =  1 + rp .* norm(v_p) .^ 2 ./ mu_earth;

p_minus = rp .* (1 + e_m);
p_plus = rp .* (1 + e_plus);

theta_minus =  acos(1 ./ e_m .* (p_minus ./ r_soi - 1));
theta_plus =    acos(1 ./ e_plus .* (p_plus ./ r_soi - 1));

F_minus = 2 * atanh(tan(theta_minus/2)*sqrt((e_m-1)/(e_m+1)));
F_plus = 2 * atanh(tan(theta_plus/2)*sqrt((e_plus-1)/(e_plus+1)));

M_minus = - (F_minus - e_m * sinh(F_minus));
M_plus = - (F_plus - e_plus * sinh(F_plus));

n_minus = sqrt(mu_earth / abs(a_minus) ^ 3);
n_plus = sqrt(mu_earth / abs(a_plus) ^ 3);

dt_minus = M_minus / n_minus;
dt_plus = M_plus / n_plus;
dt = (dt_plus + dt_minus) / 3600; %time in soi in hours

%% hyperbola in the soi

u = cross(v_m, v_p) / norm(cross(v_m, v_p));
D = [0; -1; 0]; %pass in front

delta_m =  2 * asin(1 ./ e_m);
beta_minus = pi/2 - delta_m / 2;

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

[~,Y_bk] = ode113(@(t, y) ode_2bp(t, y, mu_earth),tspan_bk,y0_bk,options);
[T,Y_fw] = ode113(@(t, y) ode_2bp(t, y, mu_earth),tspan_fw,y0_fw,options);

R_bk = Y_bk(:, 1:3);
R_fw = Y_fw(:, 1:3);

R_E = astroConstants(23);

% Terra_3D(RE)
% hold on
% grid on
% plot3(R_bk(:,1), R_bk(:,2), R_bk(:,3), 'Color', 'r', 'LineWidth',2)
% plot3(R_fw(:,1), R_fw(:,2), R_fw(:,3), 'Color','b', 'LineWidth',2)