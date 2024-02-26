function  cost_plot_TOFs(earl_dep_date, late_arr_date, n)
%
% This function displays the cost plot of the two  heliocentric legs.
% The first is the contour plot of the injection cost in the first
% heliocentric leg. On the x axis there is the departure date, in mjd2000,
% from Mars; on the y axis there is the TOF in the first leg, in mjd2000. 
% The second is the contour plot of the exit cost from the second
% heliocentric leg. On the x axis there is the fly by , in mjd2000,
% from Earth; on the y axis there is the TOF in the second leg in mjd2000.
% In both the contour plot, the cost is expressed  in km/s
%The function takes as input the two extremes of the range of dates that it
%is wanted to analyze and the number of elements of the vector of dated in
%mjd2000
%INPUT:
%     earl_dep_date  [6x1]  [year month day hour minute second]
%
%     late_dep_date  [6x1]  [year month day hour minute second]
%
%     n             [1]     [-]   
%
%
%
% Authors: Marcello Pareschi, Daniele Paternoster
% -----------------------------------------------------------------------

earl_dep_mjd2000 = date2mjd2000(earl_dep_date);
late_arr_mjd2000 = date2mjd2000(late_arr_date);

[kep_mars, ~] = uplanet (earl_dep_mjd2000, 4);

a_mars = kep_mars(1);

[kep_earth, ksun] = uplanet (earl_dep_mjd2000, 3);

a_earth = kep_earth(1);

at = (a_earth + a_mars) / 2;

TOF_hohmann = pi * sqrt(at^3/ksun);

TOF_hohmann = TOF_hohmann / 86400; %hohmann tof in days

array_mjd2000 = linspace(earl_dep_mjd2000, late_arr_mjd2000, n);

tof_array     = linspace(100, 850, n);

dV_1 = zeros(n,n); 
dV_2 = zeros(n,n);
%%

for i = 1:n
    dep = array_mjd2000(i);
    for j = 1:n
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
clr.Label.String = '$\Delta v  [km/s]$';
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
clr2.Label.String = '$\Delta v  [km/s]$';
clr2.Label.FontSize = 15;
clr2.Label.Interpreter='latex';
grid on;

return