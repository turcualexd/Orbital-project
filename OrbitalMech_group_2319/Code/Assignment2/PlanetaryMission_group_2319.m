%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                       ORBITAL MECHANICS                                 %
%                    Academic year 2023/2024                              %
%                    M.Sc. Space Engineering                              %
%                     Politecnico di Milano                               %
%                                                                         %
%             Assignment 2: Planetary Explorer Mission                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Group 2319 
% Authors:  - Marcello Pareschi
%           - Daniele Paternoster
%           - Alex Cristian Turcu
%           - Tamim Harun Or
%
% Professor: Camilla Colombo


%pre-processing
clear; close all; clc;


mu_E = astroConstants(13);   % planetary constant of Earth - [kg3/s2]
R_E = astroConstants(23);    % radius of Earth
w_E = deg2rad(15.04)/3600;   % Earth's angular velocity - [rad/s]
mu_M = astroConstants(20);   % planetary constant of Moon - [kg3/s2]
T_E = 2*pi/w_E;              % sidereal rotation period of the Earth

%given orbital parameters 
a = 42159;              % semi-major axis - [km]
e = 0.0007;             % eccentricity - [-]
incl = deg2rad(32.5934); % incllination - [rad]
OM = deg2rad(0);        % right ascension of ascending node - [rad]
om = deg2rad(85);       % argument of perigee - [rad]
hp = 35786;             % altitude at perigee - [km]; in range for geosynchronus sattelites 
n = sqrt(mu_E/a^3);     % mean angular velocity - [rad/s]
T = 2*pi/n;             % period of the orbit - [s]
p = a*(1-e^2);          % semi-latus rectum - [km]
h = sqrt(p*mu_E);       % angular momentum - [km2/s]
ra = a*(1+e);           % radius of apogee - [km]
rp = R_E + hp;          % radius of perigee - [km]

k = 1;                  % repeating groundtrack parameter of the satellite
m = 1;                  % repeating groundtrack parameter of Earth

f_0 = 0;                          % initial true anomaly - [rad]
G0 = 0;                              % initial Greenwich Longitude - [rad]
t0 = date2mjd2000([2023 1 1 0 0 0]); % initial time in MJD2000 for computing moon distuebance
kep0 = [a e incl OM om f_0];       % initial keplerian elements
[r0,v0] = kep2car(kep0,mu_E);    

options = odeset('RelTol', 1e-12, 'AbsTol', 1e-12); 


Section = input("Select code section to run (1,2,3)\n");
switch Section 


    case 1 

%%unperturbed%% 
tic

t_1orbit = linspace(0,T,10000); % one orbit time
t_1day   = linspace(0,24*3600,10000); % 1 day
t_10days = linspace(0,10*24*3600,50000); % 10 days

%non-repeating groundtrack on given parameters 
[lat_1o,lon_1o] = groundtrack(kep0,t_1orbit,t0,G0,'XYZ'); 
[lat_1d,lon_1d] = groundtrack(kep0,t_1day,t0,G0,'XYZ');
[lat_10d,lon_10d] = groundtrack(kep0,t_10days,t0,G0,'XYZ');

groundtrack_plotting(lon_1o,lat_1o,'Unperturbed Groundtrack - original orbit for 1 period');
groundtrack_plotting(lon_1d,lat_1d,'Unperturbed Groundtrack - original orbit for 1 day');
groundtrack_plotting(lon_10d,lat_10d,'Unperturbed Groundtrack - original orbit for 10 days');

%unperturbed orbit around Earth plot

[~,state_cart] = ode113(@(t,s) twoBP(s,[0;0;0],mu_E,'XYZ'),...
    t_1orbit,[r0;v0],options);
figure(length(findobj('type','figure'))+1);
h1 = gca;
earth_sphere(h1,'km');
hold on
% plot orbit
plot3(state_cart(:,1),state_cart(:,2),state_cart(:,3),'r','LineWidth',2.5);
title('Unperturbed orbit','Interpreter','latex','FontSize',15)
% label, legend and axis limits
xlabel('X [km]','Interpreter','latex');
ylabel('Y [km]','Interpreter','latex');
zlabel('Z [km]','Interpreter','latex');
grid on;
axis equal;


%repeating groundtrack 

%semi-major axis modified
a_un_r = changed_a(k,m,mu_E,T_E);      % recquired semi-major axis
kep_un_r = kep0; kep_un_r(1) = a_un_r; % keplerian elements vector
T_rep = 2*pi*sqrt(a_un_r^3/mu_E);      % period of repeating orbit
e_r = e;                               % eccentricity - [-]
incl_rt = incl;                        % incllination - [rad]
ohm_r = OM;                            % right ascension of ascending node - [rad]
omega_r = om;                          % argument of perigee - [rad]
p_r = a_un_r*(1-e_r^2);                % semi-latus rectum - [km]
h_r = sqrt(p_r*mu_E);                  % angular momentum - [km2/s]
ra_r = a_un_r*(1+e_r);                 % radius of apogee - [km]
rp_r = a_un_r*(1-e_r);                 % radius of perigee - [km]

t_1orbit_r = linspace(0,T_rep,10000);
t_korbit_r = linspace(0,4*k*T_rep,k*10000); % 4 orbits time span

[lat_1o_un_r,lon_1o_un_r] = groundtrack(kep_un_r,t_1orbit_r,t0,G0,'XYZ');
[lat_ko_un_r,lon_ko_un_r] = groundtrack(kep_un_r,t_korbit_r,t0,G0,'XYZ');

groundtrack_plotting(lon_1o_un_r,lat_1o_un_r,'Unperturbed Groundtrack - repeating orbit for 1 period');
groundtrack_plotting(lon_ko_un_r,lat_ko_un_r,'Unperturbed Groundtrack - repeating orbit for k=4 period');

%%perturbed%% 

%given original orbit with non-repeating and perturbed groundtrack
[lat_1o_pt,lon_1o_pt] = groundtrack(kep0,t_1orbit,t0,G0,'XYZ','BOTH');
[lat_1d_pt,lon_1d_pt] = groundtrack(kep0,t_1day,t0,G0,'XYZ','BOTH');
[lat_10d_pt,lon_10d_pt] = groundtrack(kep0,t_10days,t0,G0,'XYZ','BOTH');

groundtrack_plotting(lon_1o,lat_1o,'Perturbed Groundtrack - original orbit for 1 orbit');
groundtrack_plotting(lon_1o_pt,lat_1o_pt,'',length(findobj('type','figure')),{'DisplayName','Perturbed GT'});

groundtrack_plotting(lon_1d,lat_1d,'Perturbed Groundtrack - original orbit for 1 day');
groundtrack_plotting(lon_1d_pt,lat_1d_pt,'',length(findobj('type','figure')),{'DisplayName','Perturbed GT'});

groundtrack_plotting(lon_10d,lat_10d,'Perturbed Groundtrack - original orbit for 10 days');
groundtrack_plotting(lon_10d_pt,lat_10d_pt,'',length(findobj('type','figure')),{'DisplayName','Perturbed GT'});


%Repeating perturbed groundtrack

[lat_1o_pt_r,lon_1o_pt_r] = groundtrack(kep_un_r,t_1orbit_r,t0,G0,'XYZ','BOTH');
[lat_ko_pt_r,lon_ko_pt_r] = groundtrack(kep_un_r,t_korbit_r,t0,G0,'XYZ','BOTH');

groundtrack_plotting(lon_1o_un_r,lat_1o_un_r,'Perturbed Groundtrack - repeating orbit for 1 orbit');
groundtrack_plotting(lon_1o_pt_r,lat_1o_pt_r,'',length(findobj('type','figure')),{'DisplayName','Perturbed GT'});

groundtrack_plotting(lon_ko_un_r,lat_ko_un_r,'Perturbed Groundtrack - repeating orbit for 4 orbits');
groundtrack_plotting(lon_ko_pt_r,lat_ko_pt_r,'',length(findobj('type','figure')),{'DisplayName','Perturbed GT'});



    case 2 

%propagation of orbit in Cartesian Coordinates
tic
N_days = 365*0.5;  
tspan = linspace(0, N_days * 24 * 3600, N_days * 1000); 
npoints = N_days * 1000;  
func_ode = @(t, s) twoBP(s, pert(t0 + t/24/3600, s, 'XYZ'), mu_E, 'XYZ'); 
[~, car_pert] = ode113(func_ode, tspan, [r0; v0], options); 
kep_car = zeros(size(car_pert));

%Keplerian elements
 for i = 1:length(car_pert)
     s_i = car_pert(i, 1:3)';
     v_i = car_pert(i, 4:6)';
     kep_i = car2kep(s_i, v_i, mu_E);
     kep_car(i, :) = kep_i;
 end

%propagation of orbit in Keplerian elements

func_ode = @(t,s) twoBP(s,pert(t0+t/24/3600,s,'RSW',1),mu_E,'RSW');
[~,kep_rsw_pert] = ode113(func_ode,tspan,kep0,options);


%two body problem

[~,kep_rsw_pert] = ode113(func_ode,tspan,kep0,options); %data vector in gauss coordinates
[~,kep_rsw] = ode113(@(t,s) twoBP(s,[0;0;0],mu_E,'RSW'),...
    tspan,kep0,options);
[~,kep_rsw_j2] = ode113(@(t,s) twoBP(s,pert(t0+t/24/3600,s,'RSW','J2',1),mu_E,'RSW'),...
    tspan,kep0,options);
[~,kep_rsw_moon] = ode113(@(t,s) twoBP(s,pert(t0+t/24/3600,s,'RSW','MOON',1),mu_E,'RSW'),...
    tspan,kep0,options);

%Keplarian history plot with assigned perturbation plot

titles = {'Semir-major axis','Eccentricity','inclination',...      
    'RA of ascending node','Argument of perigee','True anomaly','Interpreter','latex','FontSize',15};
ylabels = {'a [km]','e [-]','i [deg]','\Omega [deg]','\omega [deg]','\theta [deg]','Interpreter','latex'};

for i = 1:6
    subplot(3,2,i);
    if i <= 2
    plot(tspan/24/3600,kep_rsw_pert(:,i),'Color','#D95319','DisplayName','Moon+J2');
    xlim([0,N_days]);
    legend('show');
    hold on
    %plot(tspan/24/3600,kep_rsw_j2(:,i),'Color','r','DisplayName','J2');
    %plot(tspan/24/3600,kep_rsw_moon(:,i),'Color','m','DisplayName','Moon');
    plot(tspan/24/3600,kep_rsw(:,i),'Color','#EDB120','DisplayName','No perturbation');
    legend('show');
    grid on
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]','Interpreter','latex');
    ylabel(ylabels{i});
    elseif i >= 3
    plot(tspan/24/3600,rad2deg(kep_rsw_pert(:,i)),'Color','#D95319','DisplayName','Moon+J2');
    legend('show');
    xlim([0,N_days]);
    hold on
    %plot(tspan/24/3600,rad2deg(kep_rsw_j2(:,i)),'Color','r','DisplayName','J2');
    %plot(tspan/24/3600,rad2deg(kep_rsw_moon(:,i)),'Color','m','DisplayName','Moon');
    plot(tspan/24/3600,rad2deg(kep_rsw(:,i)),'Color','#EDB120','DisplayName','No perturbation');
    legend('show');
    grid on
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]','Interpreter','latex');
    ylabel(ylabels{i});
    end
end

%comparison of both methods in terms of relative error plot

figure;
test=[a,e,360,360,360];
for i = 1:6
    subplot(3,2,i);
    if i <= 2
    plot(tspan/24/3600,(kep_rsw_pert(:,i)-kep_car(:,i))/test(i),'Color','#0072BD','DisplayName','Moon+J2'); 
    %kep_car = propagation of the orbit in cartesian coordinates
    %kep_rsw_pert = data vector in gauss coordinates
    hold on;
        xlim([0,N_days]);
    grid on;
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]','Interpreter','latex');
    ylabel('Relative error','Interpreter','latex');
    elseif i == 3 || i == 5
    plot(tspan/24/3600,rad2deg((kep_rsw_pert(:,i)-kep_car(:,i)))/test(i),'Color','#0072BD','DisplayName','Moon+J2');
        xlim([0,N_days]);
    % legend('Show');
    grid on
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]','Interpreter','latex');
    ylabel('Relative error','Interpreter','latex');
    elseif i==4
       temp = [zeros(1,1); rad2deg((kep_rsw_pert(2:end,i)-(kep_car(2:end,i)-2*pi)))/test(i)]; 
           plot(tspan/24/3600,temp,'Color','#0072BD','DisplayName','Moon+J2');

        xlim([0,N_days]);
    % legend('Show');
    grid on
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]','Interpreter','latex');
    ylabel('Relative error','Interpreter','latex');
    elseif i==6
     temp = [zeros(1,1); (kep_rsw_pert(2:end,i)-unwrap(kep_car(2:end,i)))./kep_rsw_pert(2:end,i)];
      plot(tspan/24/3600,temp,'Color','#0072BD','DisplayName','Moon+J2'); %unwrapping data before filtering
    % legend('Show');
    grid on
      xlim([0,N_days]);
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]','Interpreter','latex');
    ylabel('Relative error','Interpreter','latex');
    end
end

%evolution of orbit plot

figure;
axes
MyColorOrder=get(gca,'ColorOrder'); %RGB combinations per row
%make your own color order, you can even add more row (more possible colors)
set(gca,'ColorOrder',MyColorOrder); %RGB combinations per row
hold all
N=300000; %every N points change color
for j=1:N:numel(car_pert(:,1))-N
plot3(car_pert(j:j+N,1),car_pert(j:j+N,2),car_pert(j:j+N,3));
end
grid on;
hold on;
plot3(car_pert(1,1),car_pert(1,2),car_pert(1,3),'b*','MarkerSize',12);
plot3(car_pert(end,1),car_pert(end,2),car_pert(end,3),'r*','MarkerSize',12);
h1 = gca;
earth_sphere(h1,'km');
title("Orbit Representation")

%filtering plot

        figure;
        high_filter = ones(1, 6) * npoints / 100;
        low_filter = [npoints 2 * npoints npoints / 10 npoints / 50 npoints / 50 npoints / 50];
for i = 1:6
    subplot(3,2,i);
    if i <= 2
    plot(tspan/24/3600,kep_rsw_pert(:,i),'Color','#EDB120','DisplayName','Unfiltered');
        xlim([0,N_days]);
    legend('show');
    hold on
    ax = gca;
    ax.ColorOrderIndex = 5;
    plot(tspan/24/3600,movmean(kep_rsw_pert(:,i),high_filter(i)),'LineWidth',1.1,'Color','#A2142F','DisplayName','Long term behaviour');
        xlim([0,N_days]);
    legend('show');
    plot(tspan/24/3600,movmean(kep_rsw_pert(:,i),low_filter(i)),'Color','#0072BD','DisplayName','Secular');
        xlim([0,N_days]);
    legend('show');
    grid on
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]');
    ylabel(ylabels{i});
    %legend;
    elseif i >= 3
    plot(tspan/24/3600,rad2deg(kep_rsw_pert(:,i)),'Color','#EDB120','DisplayName','Unfiltered');
        xlim([0,N_days]);
    legend('show');
    hold on
    ax = gca;
    ax.ColorOrderIndex = 5;
    plot(tspan/24/3600,rad2deg(movmean(kep_rsw_pert(:,i),high_filter(i))),'LineWidth',1.1,'Color','#A2142F','DisplayName','Long term behaviour');
        xlim([0,N_days]);
    legend('show');
    plot(tspan/24/3600,rad2deg(movmean(kep_rsw_pert(:,i),low_filter(i))),'Color','#0072BD','DisplayName','Secular');
        xlim([0,N_days]);
    legend('show');
    grid on
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]');
    ylabel(ylabels{i});
    %legend;
    end
end


    case 3 


% Comparison with real data 

tic

data = extract2LE('SDO.txt'); %from 2013-02-11 to 2017-09-24

data = data(:,:);
mean_time_interval = mean(data(2:end,1)-data(1:end-1,1));
t0_tle = data(1,1);
tf_tle = data(end,1);
tspan_tle = linspace(t0_tle,tf_tle,50000); % in MJD2000
kep0_tle = [data(1,2:3) deg2rad(data(1,4:7))];


%initial orbit parameters

T_tle = 2*pi*sqrt(kep0_tle(1)^3/mu_E)/3600/24; % period of initial orbit in days
p_tle = kep0_tle(1)*(1-kep0_tle(2)^2);        
h_tle = sqrt(p_tle*mu_E);                      
ra_tle = kep0_tle(1)*(1+kep0_tle(2));
rp_tle = kep0_tle(1)*(1-kep0_tle(2));
ha_tle = ra_tle-R_E;
hp_tle = rp_tle-R_E;

%filter 

dt_num = tspan_tle(2)-tspan_tle(1);
n_filter = ceil(2*T_tle/dt_num); % for every 2 orbits
filter_freq = 1/(tspan_tle(n_filter+1)-tspan_tle(1)); 




% propagate orbit from initial data

func_ode = @(t,s) twoBP(s,pert(t/24/3600,s,'RSW',1),mu_E,'RSW');
[~,kep_tle] = ode113(func_ode,tspan_tle*24*3600,kep0_tle,options);

titles = {'Semi-major axis','Eccentricity','inclination',...
    'RA of ascending node','Argument of perigee','True anomaly','Interpreter','latex','FontSize',15};
ylabels = {'Semi-major axis [km]','Eccentricity [-]','Inclination [deg]',...
    'RAAN [deg]','Argument of perigee [deg]','True anomaly [deg]','Interpreter','latex'};
for i = 1:6
    figure(length(findobj('type','figure'))+1);
    if i <= 2
    plot(tspan_tle,kep_tle(:,i),'Color','#0072BD','DisplayName','Numerical');
    hold on
    plot(tspan_tle,movmean(kep_tle(:,i),n_filter),'c','DisplayName','Filtered', 'LineWidth',1.5);
    plot(data(:,1),data(:,i+1),'Color','#7E2F8E','DisplayName','TLE', 'LineWidth',1.5);
    grid on
    title(titles{i});
    xlabel('Time [MJD2000]','Interpreter','latex');
    ylabel(ylabels{i},'Interpreter','latex');
    legend;
    xlim([t0_tle,tf_tle]);
    elseif i >= 3
    plot(tspan_tle,rad2deg(kep_tle(:,i)),'Color','#0072BD','LineWidth',1.5,'DisplayName','Numerical');
    hold on
    grid on
    plot(tspan_tle,rad2deg(movmean(kep_tle(:,i),n_filter)),'c--','LineWidth',1.5,'DisplayName','Filtered');
    plot(data(:,1),data(:,i+1),'Color','#7E2F8E','LineWidth',1.5,'DisplayName','TLE');
    title(titles{i});
    xlabel('Time [MJD2000]','Interpreter','latex');
    ylabel(ylabels{i},'Interpreter','latex');
    legend;
    xlim([t0_tle,tf_tle]);
    end
end


tspan_tle_eq = data(:,1); 

func_ode = @(t,s) twoBP(s,pert(t/24/3600,s,'RSW',1),mu_E,'RSW');
[~,kep_tle_eq] = ode113(func_ode,tspan_tle_eq*24*3600,kep0_tle,options);

r_vec_data = zeros(length(tspan_tle_eq),3);
r_vec_tle = zeros(length(tspan_tle_eq),3);
distance_vec = zeros(length(tspan_tle_eq),1);

for i = 1:length(tspan_tle_eq)
    kep = [data(i,2:3),deg2rad(data(i,4:end))];
    [ri_d,~] = kep2car(kep,mu_E);
    r_vec_data(i,:) = ri_d';
    
    [ri_tle,~] = kep2car(kep_tle_eq(i,:),mu_E);
    r_vec_tle(i,:) = ri_tle';
    
    distance_vec(i) = norm(ri_tle-ri_d);
end

mean_error = mean(distance_vec);
RMSE = sqrt(mean((distance_vec - mean_error).^2));% Root Mean Squared Error

%distance error 

figure;
plot(tspan_tle_eq,distance_vec);
grid on;
xlabel('Time [MJD2000]','Interpreter','latex');
ylabel('Distance error [km]','Interpreter','latex');
xlim([t0_tle,tf_tle]);


npoints = length(tspan_tle_eq);  
func_ode = @(t, s) twoBP(s, pert(t/24/3600, s, 'RSW', 1), mu_E, 'RSW');
[~, kep_tle] = ode113(func_ode, tspan_tle * 24 * 3600, kep0_tle, options);  


otherwise
        error("invalid Section");
end
fprintf("\nEnd of part %d\n",Section);  

% fprintf("n_filter = %d \n", n_filter);
% fprintf("dt_num = %f \n", dt_num);
% 
% fprintf('Initial Keplerian elements:\n');
% fprintf('Semi-major axis = %f km\n', kep0_tle(1));
% fprintf('Eccentricity = %f\n', kep0_tle(2));
% fprintf('Inclination = %f deg\n', rad2deg(kep0_tle(3)));
% fprintf('Right ascension of ascending node = %f deg\n', rad2deg(kep0_tle(4)));
% fprintf('Argument of perigee = %f deg\n', rad2deg(kep0_tle(5)));
% fprintf('Mean anomaly = %f deg\n', rad2deg(kep0_tle(6)));

toc






