clear;

close all;

clc;

R = astroConstants(2);

G = astroConstants(1); 

mu_sun = astroConstants(4);

mu_earth = astroConstants(13);

m_sun = mu_sun / G; 

m_earth = mu_earth / G;

r_soi = R * (m_earth / m_sun) ^ (2 / 5);

rp = 8.727882503720639e+03;

v_m = [
  -6.635041825353301;
   3.851995168543024;
  -0.887754818878237];

v_p =[
  -7.178359580538917;
  -2.150619802178095;
   1.869686095289515];

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
%%

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
%%
v_m = v_m/norm(v_m);
v_p = v_p / norm(v_p);
figure
hold on
quiver3(0, 0, 0, u(1), u(2), u(3))
quiver3(0, 0, 0, u(1), u(2), u(3))
quiver3(0, 0, 0, u(1), u(2), u(3))