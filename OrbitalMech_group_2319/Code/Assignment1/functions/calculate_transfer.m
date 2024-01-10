function [dvs, kep_arc1_i, kep_arc2_i, dtheta_arc1, dtheta_arc2, rp, ratio, T_SOI] = ...
calculate_transfer(dep, fb, arr)

%----------------Calculate transfer arcs of the mission--------------------
%
% This function calculates all the data necessary to define and plot the
% selected strategy from the given dates. Two plots are computed: the first
% in a heliocentric frame in order to appreciate the transfer arcs between
% the celestial parts, the second to better see the fly by in a geocentric
% frame.
%
%--------------------------------------------------------------------------
% 
% INPUT:
% dep               [1]: time of departure from Mars in mjd2000
% fb                [1]: time of fly by on Earth in mjd2000
% dep               [1]: time of arrival on 1036 Ganymed in mjd2000
%
% OUTPUT:
% dvs             [3x1]: vector containing dv of departure, arrival and 
%                        fly by (in this specific order), in km/s
% kep_arc1_i      [6x1]: keplerian elements describing the first Lambert
%                        arc, in particular referred to the initial point
% kep_arc2_i      [6x1]: keplerian elements describing the second Lambert
%                        arc, in particular referred to the initial point
% dtheta_arc1       [1]: angle covered on the first transfer arc, in rad
% dtheta_arc2       [1]: angle covered on the second transfer arc, in rad
% rp                [1]: radius at pericentre of hyperbolic trajectory
%                        around Earth, in km
% ratio             [1]: ratio between the DV of the impulsive manoeuvre at
%                        the pericentre of the flyby and the total DV
%                        provided by the flyby
%
%--------------------------------------------------------------------------
%
% AUTHOR: Alex Cristian Turcu
%
%--------------------------------------------------------------------------

%% Heliocentric transfers

% Ephemerides calculation
[kep_Mars_dep, mu_S] = uplanet(dep, 4);
kep_Earth_fb = uplanet(fb, 3);
kep_NEO_arr = ephNEO(arr, 65);

% Convert from Keplerian to cartesian coordinates
[R_Mars_dep, ~] = kep2car(kep_Mars_dep, mu_S);
[R_Earth_fb, V_Earth_fb] = kep2car(kep_Earth_fb, mu_S);
[R_NEO_arr, ~] = kep2car(kep_NEO_arr, mu_S);

% Compute dvs
[dv1, ~, V_m] = cost_lambert(dep, fb, 4, 3, 0);
[dv2, V_p, ~] = cost_lambert_2(fb, arr, 3, 65, 0);
[dv3, ~] = cost_gravity_assist(fb, 3, V_m, V_p);
dvs = [dv1; dv2; dv3];

TOF1 = (fb - dep) * 60^2 * 24;
TOF2 = (arr - fb) * 60^2 * 24;

% Calculate elliptical arcs
[~,~,~,~, vi_arc1, vf_arc1, ~, dtheta_arc1] = lambertMR(R_Mars_dep,R_Earth_fb,TOF1,mu_S,0,0);
kep_arc1_i = car2kep(R_Mars_dep, vi_arc1, mu_S);

[~,~,~,~, vi_arc2, ~, ~, dtheta_arc2] = lambertMR(R_Earth_fb,R_NEO_arr,TOF2,mu_S,0,0);
kep_arc2_i = car2kep(R_Earth_fb, vi_arc2, mu_S);

% Plot Solar system
dth = pi / 100;

figure
Sun_3D(70)
Mars_3D(R_Mars_dep, 4000)
Terra_3D(R_Earth_fb, 4000)
NEO_3D(R_NEO_arr, 5e5)

plotorbit_dotted(kep_Mars_dep, 0, 2*pi, dth, mu_S, "#A2142F")
plotorbit_dotted(kep_Earth_fb, 0, 2*pi, dth, mu_S, 'g')
plotorbit_dotted(kep_NEO_arr, 0, 2*pi, dth , mu_S, 'm')

plotorbit(kep_arc1_i, kep_arc1_i(6), kep_arc1_i(6) + dtheta_arc1, dth, mu_S, 'b')
plotorbit(kep_arc2_i, kep_arc2_i(6), kep_arc2_i(6) + dtheta_arc2, dth, mu_S, 'r')

legend('', '', '', '', 'Orbit of Mars', 'Orbit of Earth', ...
    'Orbit of 1036 Ganymed', '1st Lambert arc', '2nd Lambert arc')

%% Hyperbola transfer

% Calculate ratio of the fly by
ratio = dvs(3) / norm(vf_arc1 - vi_arc2);

% Calculate hyperbola legs in perifocal frame
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
%delta_p = 2 * asin(1 / e_p);

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

% plot in perifocal frame
% figure
% hold on
% axis equal
% plot(r_per_m(1,:), r_per_m(2,:))
% plot(r_per_p(1,:), r_per_p(2,:))

% Rotation to inertial frame
beta_m = (pi - delta_m) / 2;
v_m_unit = v_m / norm(v_m);
v_p_unit = v_p / norm(v_p);
xp = rodrigues(v_m_unit,u,-beta_m);
yp = cross(u, xp);
R = [xp yp u];          % Rotation matrix from perifocal to inertial

R_N_m = R * r_per_m;
R_N_p = R * r_per_p;

% asymptots
C_N_m = -R * [a_m*e_m; 0; 0];
C_N_p = -R * [a_p*e_p; 0; 0];

% Plot hyperbola
Terra_3D_original
plot3(R_N_m(1,:), R_N_m(2,:), R_N_m(3,:), 'LineWidth', 1.5)
plot3(R_N_p(1,:), R_N_p(2,:), R_N_p(3,:), 'LineWidth', 1.5)
plot3(xp(1) * [-3 2] * 1e4, xp(2) * [-3 2] * 1e4, xp(3) * [-3 2] * 1e4, 'k--')
plot3(C_N_m(1) + v_m_unit(1) * [-4 0] * 1e4, C_N_m(2) + v_m_unit(2) * [-4 0] * 1e4, C_N_m(3) + v_m_unit(3) * [-4 0] * 1e4, 'b--')
plot3(C_N_p(1) + v_p_unit(1) * [0 4] * 1e4, C_N_p(2) + v_p_unit(2) * [0 4] * 1e4, C_N_p(3) + v_p_unit(3) * [0 4] * 1e4, 'r--')
legend('', 'Incoming hyperbola', 'Outcoming hyperbola', 'Apse line', 'Asymptote for incoming hyperbola', 'Asymptote for outcoming hyperbola')

%% Time in SOI

AU = astroConstants(2);
G = astroConstants(1);
mu_sun = astroConstants(4);
mu_earth = astroConstants(13);
m_sun = mu_sun / G;
m_earth = mu_earth / G;

r_soi = AU * (m_earth / m_sun) ^ (2 / 5);

p_m = rp .* (1 + e_m);
p_p = rp .* (1 + e_p);

theta_m =  acos(1 ./ e_m .* (p_m ./ r_soi - 1));
theta_p =    acos(1 ./ e_p .* (p_p ./ r_soi - 1));

% Eccentric anomalies
F_m = 2 * atanh(tan(theta_m/2)*sqrt((e_m-1)/(e_m+1)));
F_p = 2 * atanh(tan(theta_p/2)*sqrt((e_p-1)/(e_p+1)));

% Mean anomalies
M_m = - (F_m - e_m * sinh(F_m));
M_p = - (F_p - e_p * sinh(F_p));

% Mean motions
n_m = sqrt(mu_earth / abs(a_m) ^ 3);
n_p = sqrt(mu_earth / abs(a_p) ^ 3);

dt_m = M_m / n_m;
dt_p = M_p / n_p;
T_SOI = (dt_p + dt_m) / 3600; % time in soi in hours