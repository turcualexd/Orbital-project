clear; close all; clc;

earl_dep_date = [2028 01 01 00 00 00];
late_arr_date = [2041 01 01 00 00 00];


num             = 200; %number of elements of array of mjd2000 

earl_dep_mjd2000 = date2mjd2000(earl_dep_date);
late_arr_mjd2000 = date2mjd2000(late_arr_date);

[kep_mars, ~] = uplanet (earl_dep_mjd2000, 4);

a_mars = kep_mars(1);

[kep_earth, ksun] = uplanet (earl_dep_mjd2000, 3);

a_earth = kep_earth(1);

at = (a_earth + a_mars) / 2;

TOF_hohmann = pi * sqrt(at^3/ksun);

TOF_hohmann = TOF_hohmann / 86400; %hohmann tof in days

range = linspace(0.2,2,5);

array_mjd2000 = linspace(earl_dep_mjd2000, late_arr_mjd2000, num);

tof_array     = linspace(100, 850, num);

dV_1 = zeros(num,num); 
dV_2 = zeros(num,num);
%%
for i = 1:num
    dep = array_mjd2000(i);
    for j = 1:num
        tof = tof_array(j);
        [dV_1(j,i), ~, ~] = cost_lambert(dep, dep+tof, 4, 3, 0);
        [dV_2(j,i), ~, ~] = cost_lambert_2(dep, dep+tof, 3, 65 , 0);
    end
end

figure;
hold on
[X,Y] = meshgrid(array_mjd2000, tof_array);
contour(X,Y,dV_1,linspace(0,6,500));
for i = 1 : length(range)

    plot(array_mjd2000, range(i)*TOF_hohmann*ones(size(array_mjd2000)), 'Color','k', 'LineWidth',2)
end
title('Mars - Earth Leg')
xlabel('Departure MJD200'); ylabel('TOF MJD200')
colorbar
grid on;

figure;
[X,Y] = meshgrid(array_mjd2000, tof_array);
contour(X,Y,dV_2,linspace(0,6,500));
title('Earth - Asteroid65 Leg')
xlabel('Departure MJD200'); ylabel('TOF MJD200')
colorbar
grid on;