clear; close all; clc;

AU = astroConstants(2);

e1 = [1; 0; 0];

% date_dep = [2028, 1, 1, 0, 0, 0];
% 
% date_arr = [2058, 1, 1, 0, 0, 0];
% 
% range = [date2mjd2000(date_dep), date2mjd2000(date_arr)];

range = [1.0226e+04, 1.0226e+04+13*365];

t = linspace(range(1), range(2), 1e3);

dist = NaN(size(t));

phas = dist;

for i = 1 : length(t)

    [kep1,~] = uplanet(t(i), 4);

    [kep2,mu_sun] = uplanet(t(i), 3);

    [kep3] = ephNEO(t(i),65);

    [R1, V1] = kep2car(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),kep1(6), mu_sun);

    [R2, V2] = kep2car(kep2(1),kep2(2),kep2(3),kep2(4),kep2(5),kep2(6), mu_sun);

    [R3, V3] = kep2car(kep3(1),kep3(2),kep3(3),kep3(4),kep3(5),kep3(6), mu_sun);

    r21 = norm(R2-R1);

    r32 = norm(R3-R2);

    dist(i) = r21 + r32;

    r1 = R1 / norm(R1);

    r2 = R2 / norm(R2);

    r3 = R3 / norm(R3);

    phi1 = acos(dot(e1, r1));

    phi2 = acos(dot(e1, r2));

    phi3 = acos(dot(e1, r3));

    phas(i) = abs(phi1 - phi2) + abs(phi2 - phi3);

end

%%

dates = convert_do_date(t);

figure

hold on

grid minor

plot(t, dist/AU)

xlabel('time [mdjd2000]')

ylabel('sum of relative distances [AU]')

figure

hold on

grid minor

plot(t, phas)

xlabel('time [mdjd2000]')

ylabel('sum of phasing')