function cost_plot(earl_dep_date, late_arr_date)

% This function creates the  cost plot for first arc (injection dV) and cost plot
% for second arc (exit dV). No numerical output is given.
% 
% INPUT: 
% earl_dep_date [1 x 6] as [yyyy mm dd hh mm ss] date in gregorian calendar
% late_arr_date [1 x 6] as [yyyy mm dd hh mm ss] date in gregorian calendar
% OUTPUT: graphs
%
% AUTHOR: Daniele Paternoster
% -------------------------------------------------------------------------

earl_dep_mjd2000 = date2mjd2000(earl_dep_date);
late_arr_mjd2000 = date2mjd2000(late_arr_date);

num           = 100; %number of elements of array of mjd2000 
array_mjd2000 = linspace(earl_dep_mjd2000, late_arr_mjd2000, num);
tof_array     = array_mjd2000 - earl_dep_mjd2000*ones(1,num);

% inizialize the variables. consider as domain departure and arrival (as
% symmetrical domains).
dV_1 = zeros(num,num); 
dV_2 = zeros(num,num); 

% calculate the costs using cost_lambert and cost_lambert_2

for i = 1:num

    earl_dep_date = array_mjd2000(i);
    for j=i:num

    late_arr_date = array_mjd2000(j);  
    [dV_1(j,i), ~, ~] = cost_lambert(earl_dep_date, late_arr_date, 4, 3, 0);
    [dV_2(j,i), ~, ~] = cost_lambert_2(earl_dep_date, late_arr_date, 3, 65 , 0);
    end

end

%--------------------GRAPHICS - Plot previous results----------------------

% First plot - Mars to Earth leg using contour plot also small zoomed box
% added

figure;
[X,Y] = meshgrid(array_mjd2000, array_mjd2000);
contour(X,Y,dV_1,linspace(1,10,500),'LineWidth',1.5);
title('Mars - Earth Leg', 'Interpreter','latex', 'FontSize',12)
xlabel("Departure MJD2000", 'Interpreter','latex');
ylabel('Arrival MJD2000', 'Interpreter','latex')
clr = colorbar;
clr.Label.String = '$\Delta v  [km/s]$';
clr.Label.FontSize = 15;
clr.Label.Interpreter='latex';
axis equal;
grid on;

% create zoomed box for a particular minimum
axes('position',[.50 .25 .25 .25])
box on
% minimum zone individated graphically
earl_dep_date_z    = [2031 07 06 00 00 00];
late_arr_date_z    = [2034 12 06 00 00 00];
earl_dep_z_mjd2000 = date2mjd2000(earl_dep_date_z);
late_arr_z_mjd2000 = date2mjd2000(late_arr_date_z);
num                = 100; %number of elements of array of mjd2000 

array_mjd2000_z    = linspace(earl_dep_z_mjd2000, late_arr_z_mjd2000, num);
tof_array          = array_mjd2000_z - earl_dep_z_mjd2000*ones(1,num);
dV_1 = zeros(num,num); 

% calculate solution for zoomed box to get more resolution
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


% Second plot - Earth to Mars leg using contour plot
figure;
[X,Y] = meshgrid(array_mjd2000, array_mjd2000);
contour(X,Y,dV_2,linspace(1,10,500), 'LineWidth',1.5);
title('Earth - 1036 Ganymed Leg', 'Interpreter','latex', 'FontSize',12)
xlabel("Departure MJD2000", 'Interpreter','latex');
ylabel('Arrival MJD2000', 'Interpreter','latex')
clr2 = colorbar;
clr2.Label.String = '$\Delta v  [km/s]$';
clr2.Label.FontSize = 15;
clr2.Label.Interpreter='latex';
axis equal;
grid on;


end