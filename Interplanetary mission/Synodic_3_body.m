clear, clc, close all;

date_dep = [2028, 1, 1, 0, 0, 0];
date_arr = [2058, 1, 1, 0, 0, 0];

dep = date2mjd2000(date_dep);
arr = date2mjd2000(date_arr);

[kep_Earth, mu_S] = uplanet(dep, 3);
a_Earth = kep_Earth(1);

kep_Mars = uplanet(dep, 4);
a_Mars = kep_Mars(1);

kep_NEO = ephNEO(dep, 65);
a_NEO = kep_NEO(1);

period = @(a) 2*pi * sqrt(a^3 / mu_S) / (60^2 * 24);
T_Earth = period(a_Earth);
T_Mars = period(a_Mars);
T_NEO = period(a_NEO);

T = (0:1:20000).';

y_Earth = 1/T_Earth * T;
y_Mars = 1/T_Mars * T;
y_NEO = 1/T_NEO * T;

i_res = [];
tol = 0.1;
dec_part = @(x) abs(x - round(x));
for i = 1:length(T)
    if dec_part(y_Earth(i)) < tol && dec_part(y_Mars(i)) < tol && dec_part(y_NEO(i)) < tol
        i_res = [i_res; i];
    end
end

T_res = T(i_res);
i = y_Earth(i_res);
j = y_Mars(i_res);
k = y_NEO(i_res);