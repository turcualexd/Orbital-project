clear; close all; clc; 

date_dep = [2028, 1, 1, 0, 0, 0];

date_arr = [2058, 1, 1, 0, 0, 0];

min_dep = date2mjd2000(date_dep);

max_arr = date2mjd2000(date_arr);

%range = [date2mjd2000(date_dep), date2mjd2000(date_arr)];

range = [1.0226e+04, 1.0226e+04+13*365];

N = 300;

[dv_min, dep, fb, arr] = monte_optim(range, N, min_dep, max_arr);

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

[A1,P1,E1,ERROR,VI,VF,TPAR,THETA1] = lambertMR(R1,R2,TOF1,mu_s,orbitType,0);

[~,~,I1,O1,W1,theta1] = car2kep(R1,VI', mu_s);

[A2,P2,E2,ERROR,VI,VF,TPAR,THETA2] = lambertMR(R2,R3,TOF2,mu_s,orbitType,0);

[~,~,I2,O2,W2,theta2] = car2kep(R2,VI', mu_s);

dth = pi / 50;

figure

hold on

plotorbit(kep1(1),kep1(2),kep1(3),kep1(4),kep1(5),kep1(6), kep1(6)+2*pi, dth, mu_s, 'r')

plotorbit(kep2(1),kep2(2),kep2(3),kep2(4),kep2(5),kep2(6), kep2(6)+2*pi, dth, mu_s, 'b')

plotorbit(kep3(1),kep3(2),kep3(3),kep3(4),kep3(5),kep3(6), kep3(6)+2*pi, dth, mu_s, 'm')

plotorbit(A1,E1,I1,O1,W1,theta1, theta1+THETA1, dth, mu_s, 'g')

plotorbit(A2,E2,I2,O2,W2,theta2, theta2+THETA2, dth, mu_s, 'k')
