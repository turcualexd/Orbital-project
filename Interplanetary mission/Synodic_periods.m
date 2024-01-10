clear, clc, close all;

mu_S = astroConstants(4);
period = @(a) 2*pi * sqrt(a^3 / mu_S) / (60^2 * 24);
n = @(T) 2*pi / T;

t_0 = date2mjd2000([2028, 1, 1, 0, 0, 0]);

% Earth ->  1
kep_1 = uplanet(t_0, 3);
a_1 = kep_1(1);
T_1 = period(a_1);
n_1 = n(T_1);

% Mars  ->  2
kep_2 = uplanet(t_0, 4);
a_2 = kep_2(1);
T_2 = period(a_2);
n_2 = n(T_2);

% NEO   ->  3
kep_3 = ephNEO(t_0, 65);
a_3 = kep_3(1);
T_3 = period(a_3);
n_3 = n(T_3);

Tsynodic = @(n1, n2) 2*pi / abs(n1 - n2);

Tsyn_Earth_Mars = Tsynodic(n_1, n_2);
Tsyn_Earth_NEO  = Tsynodic(n_1, n_3);
Tsyn_Mars_NEO   = Tsynodic(n_2, n_3);

i = 1;
k = i * T_1 / T_3;
tol = 0.12;
distance_from_int = @(x) abs(x - round(x));
while distance_from_int(k) > tol
    i = i + 1;
    k = i * T_1 / T_3;
end

T_res_Earth_NEO = i * T_1;