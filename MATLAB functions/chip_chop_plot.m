clear; close all; clc;

% Create cost plot for the 1st DV on 1st lambert arc (Mars - Earth) and
% cost plot for last DV on 2nd lambert arc (Earth - Asteroid65) 

earl_dep_date = [2028 01 01 00 00 00];
late_arr_date = [2041 01 01 00 00 00];

% earl_dep_date = [2031 06 06 00 00 00];
% late_arr_date = [2034 12 06 00 00 00];

earl_dep_mjd2000 = date2mjd2000(earl_dep_date);
late_arr_mjd2000 = date2mjd2000(late_arr_date);


num             = 100; %number of elements of array of mjd2000 

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
close all;
dep_alex = date2mjd2000([2035 5 20 16 02 24.72]);
fb_alex  = date2mjd2000([2036 2 7 4 13 15.98]);
arr_alex = date2mjd2000([2039 01 16 01 41 18.39]);

figure;
[X,Y] = meshgrid(array_mjd2000, array_mjd2000);
contour(X,Y,dV_1,linspace(1,10,500),'LineWidth',1.5);
title('Mars - Earth Leg', 'Interpreter','latex', 'FontSize',12)
xlabel("Departure MJD2000", 'Interpreter','latex');
ylabel('Arrival MJD2000', 'Interpreter','latex')
clr = colorbar;
clr.Label.String = '$\Delta v \, [km/s]$';
clr.Label.FontSize = 15;
clr.Label.Interpreter='latex';
axis equal;
grid on;
axes('position',[.50 .25 .25 .25])
box on
earl_dep_date_z = [2031 07 06 00 00 00];
late_arr_date_z = [2034 12 06 00 00 00];
earl_dep_z_mjd2000 = date2mjd2000(earl_dep_date_z);
late_arr_z_mjd2000 = date2mjd2000(late_arr_date_z);
num             = 100; %number of elements of array of mjd2000 

array_mjd2000_z = linspace(earl_dep_z_mjd2000, late_arr_z_mjd2000, num);

tof_array     = array_mjd2000_z - earl_dep_z_mjd2000*ones(1,num);

dV_1 = zeros(num,num); 

for i = 1:num

    earl_dep_date_z = array_mjd2000_z(i);
    
    for j=i:num
    
    late_arr_date_z = array_mjd2000_z(j);  
    [dV_1(j,i), ~, ~] = cost_lambert(earl_dep_date_z, late_arr_date_z, 4, 3, 0);
    end


end
[X,Y] = meshgrid(array_mjd2000_z, array_mjd2000_z);
contour(X,Y,dV_1,linspace(1,10,500),'LineWidth',1.5);
grid on;
axis tight;
%xline(dep_alex);
%yline(fb_alex);

figure;
[X,Y] = meshgrid(array_mjd2000, array_mjd2000);
contour(X,Y,dV_2,linspace(1,10,500), 'LineWidth',1.5);
title('Earth - Asteroid65 Leg', 'Interpreter','latex', 'FontSize',15)
xlabel("Departure MJD2000", 'Interpreter','latex');
ylabel('Arrival MJD2000', 'Interpreter','latex')
clr2 = colorbar;
clr2.Label.String = '$\Delta v \, [km/s]$';
clr2.Label.FontSize = 15;
clr2.Label.Interpreter='latex';
axis equal;
grid on;
%xline(fb_alex);
%yline(arr_alex);



% kep_earth = uplanet(array_mjd2000(1),3);
% kep_mars  = uplanet(array_mjd2000(1),4);
% mu_S      = astroConstants(4);
% T_earth = 

%%
% 
% 
% dep_marcello = date2mjd2000([2033 6 3 21 10 9.67]);
% fb_marcello  = date2mjd2000([2034 2 10 5 31 10.79]);
% arr_marcello = date2mjd2000([2036 03 27 23 18 31.76]);
% 
% figure;
% [X,Y] = meshgrid(array_mjd2000, array_mjd2000);
% contour(X,Y,dV_1,linspace(1,10,500));
% title('Mars - Earth Leg', 'Interpreter','latex', 'FontSize',15)
% xlabel("Departure MJD2000"+newline+"$\Delta v \, [km/s]$", 'Interpreter','latex');
% ylabel('Arrival MJD2000', 'Interpreter','latex')
% clr = colorbar;
% clr.Label.String = '$\Delta v \, [km/s]$';
% clr.Label.FontSize = 15;
% clr.Label.Interpreter='latex';
% axis equal;
% grid on;
% xline(dep_marcello);
% yline(fb_marcello);
% 
% figure;
% [X,Y] = meshgrid(array_mjd2000, array_mjd2000);
% contour(X,Y,dV_2,linspace(1,10,500));
% title('Earth - Asteroid65 Leg', 'Interpreter','latex', 'FontSize',15)
% xlabel("Departure MJD2000"+newline+"$\Delta v \, [km/s]$", 'Interpreter','latex');
% ylabel('Arrival MJD2000', 'Interpreter','latex')
% clr2 = colorbar;
% clr2.Label.String = '$\Delta v \, [km/s]$';
% clr2.Label.FontSize = 15;
% clr2.Label.Interpreter='latex';
% axis equal;
% grid on;
% xline(fb_marcello);
% yline(arr_marcello);