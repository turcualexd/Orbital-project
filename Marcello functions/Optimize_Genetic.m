clear; close all; clc; 

date_dep = [2028, 1, 1, 0, 0, 0];

date_arr = [2058, 1, 1, 0, 0, 0];

f = @(x) Cost_Maneuver(x);

A = [1 1 1; -1 0 0; 1 0 0; 0 -1 0; 0 1 0;0 0 -1; 0 0 1];

b = [date2mjd2000(date_arr); -1.55e4; 1.65e4; -260; 310; -700; 780];
% % 
% A = [1 1 1; -1 0 0];
% 
% b = [date2mjd2000(date_arr);date2mjd2000(date_dep)];

options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf);

options.InitialPopulationRange = [-10; 90];
%%

[x, fval] = ga(f, 3,A, b,[],[],[],[],[], options);

disp(['Optimized Delta-V: ', num2str(x)]);

disp(['Cost: ', num2str(fval)]);

%%
dep_date = mjd20002date(x(1));

arr_date = mjd20002date(x(1)+x(2)+x(3));

time = (x(2)+x(3))/365;%years


%dep date = 16087.2988 julianday2000
%TOF1 = 302.632601julianday2000
%TOF2 = 763.539834
