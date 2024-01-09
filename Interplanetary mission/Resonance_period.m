clear, clc, close all;

mu_S = astroConstants(4);
period = @(a) 2*pi * sqrt(a^3 / mu_S) / (60^2 * 24);
t_0 = date2mjd2000([2028, 1, 1, 0, 0, 0]);

% Earth ->  1, i
kep_1 = uplanet(t_0, 3);
a_1 = kep_1(1);
T_1 = period(a_1);

% Mars  ->  2, j
kep_2 = uplanet(t_0, 4);
a_2 = kep_2(1);
T_2 = period(a_2);

% NEO   ->  3, k
kep_3 = ephNEO(t_0, 65);
a_3 = kep_3(1);
T_3 = period(a_3);

i = 1;
j = i * T_1 / T_2;
k = i * T_1 / T_3;

tol = 0.1159;
distance_from_int = @(x) abs(x - round(x));
while distance_from_int(j) > tol || distance_from_int(k) > tol
    i = i + 1;
    j = i * T_1 / T_2;
    k = i * T_1 / T_3;
end