clear; close all; clc;
%
% This code displays the cost plot of the two  heliocentric legs.
% The first is the contour plot of the injection cost in the first
% heliocentric leg. On the x axis there is the departure date, in mjd2000,
% from Mars; on the y axis there is the TOF in the first leg, in mjd2000. 
% The second is the contour plot of the exit cost from the second
% heliocentric leg. On the x axis there is the fly by , in mjd2000,
% from Earth; on the y axis there is the TOF in the second leg in mjd2000.
% In both the contour plot, the cost is expressed  in km/s
% Authors: Marcello Pareschi, Daniele Paternoster
% -----------------------------------------------------------------------

earl_dep_date = [2028 01 01 00 00 00];
late_arr_date = [2041 01 01 00 00 00];

num           = 200; %number of elements of array of mjd2000 

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
yline(0.5.*TOF_hohmann,'color',"#EDB120",'LineWidth',1.2,'LineStyle','--');
yline(TOF_hohmann,'color',"#77AC30",'LineWidth',1.2,'LineStyle','--');
yline(1.5.*TOF_hohmann,'color',"#D95319",'LineWidth',1.2,'LineStyle','--');
yline(2.*TOF_hohmann,'color',"#0072BD",'LineWidth',1.2,'LineStyle','--');
lgd = legend('', '0.5 $\Delta T_{Hoh}$', '1 $\Delta T_{Hoh}$','1.5 $\Delta T_{Hoh}$','2 $\Delta T_{Hoh}$');
lgd.Interpreter = 'latex';
title('Mars - Earth Leg', 'Interpreter','latex', 'FontSize',15)
xlabel("Departure MJD2000", 'Interpreter','latex'); ylabel('TOF MJD2000', 'Interpreter','latex')
clr = colorbar;
clr.Label.String = '$\Delta v \, [km/s]$';
clr.Label.FontSize = 15;
clr.Label.Interpreter='latex';
grid on;
ylim([100 600]);

figure;
[X,Y] = meshgrid(array_mjd2000, tof_array);
contour(X,Y,dV_2,linspace(0,6,500));
title('Earth - 1036 Ganymed Leg', 'Interpreter','latex', 'FontSize',15)
xlabel("Departure MJD2000", 'Interpreter','latex'); ylabel('TOF MJD2000', 'Interpreter','latex')
xline(1.23*1e4,'color',"#D95319",'LineWidth',1.2,'LineStyle','--');
xline(1.26*1e4,'color',"#D95319",'LineWidth',1.2,'LineStyle','--');
clr2 = colorbar;
clr2.Label.String = '$\Delta v \, [km/s]$';
clr2.Label.FontSize = 15;
clr2.Label.Interpreter='latex';
grid on;