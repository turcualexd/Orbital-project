clear; close all; clc;

% Create cost plot for the 1st DV on 1st lambert arc (Mars - Earth) and
% cost plot for last DV on 2nd lambert arc (Earth - Asteroid65) 

earl_dep_date = [2033 04 01 00 00 00];
late_arr_date = [2067 09 28 00 00 00];

earl_dep_mjd2000 = date2mjd2000(earl_dep_date);
late_arr_mjd2000 = date2mjd2000(late_arr_date);


num             = 1500; %number of elements of array of mjd2000 

array_mjd2000 = linspace(earl_dep_mjd2000, late_arr_mjd2000, num);

tof_array     = array_mjd2000 - earl_dep_mjd2000*ones(1,num);

dV_1 = zeros(num,num); 
dV_2 = zeros(num,num); 

for i = 1:num

    earl_dep_date = array_mjd2000(i);
    
    for j=i:num
    
    late_arr_date = array_mjd2000(j);  
    [dV_1(j,i), ~, ~] = cost_lambert(earl_dep_date, late_arr_date, 4, 3, 0);
    [dV_2(j,i), ~, ~] = cost_lambert_2(earl_dep_date, late_arr_date, 3, 65 , 0);
    end


end
%%

figure;
[X,Y] = meshgrid(array_mjd2000, array_mjd2000);
contour(X,Y,dV_1,linspace(1,10,10));
title('Mars - Earth Leg')
xlabel('Departure MJD200'); ylabel('Arrival MJD200')
colorbar
axis equal;
grid on;

figure;
[X,Y] = meshgrid(array_mjd2000, array_mjd2000);
contour(X,Y,dV_2,linspace(1,10,10));
title('Earth - Asteroid65 Leg')
xlabel('Departure MJD200'); ylabel('Arrival MJD200')
colorbar
axis equal;
grid on;

%%

% kep_earth = uplanet(array_mjd2000(1),3);
% kep_mars  = uplanet(array_mjd2000(1),4);
% mu_S      = astroConstants(4);
% T_earth = 


