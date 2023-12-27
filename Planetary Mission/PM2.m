
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
hp = 35788;             % altitude at perigee - [km]; in range for geosynchronus sattelites 
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
[r0,v0] = kep2car(kep0,mu_E);    % converts the Keplerian elements to Cartesian coordinates 

options = odeset('RelTol', 1e-12, 'AbsTol', 1e-12); 


%%unperturbed%% 

tic

t_1orbit = linspace(0,T,10000); % one orbit time
t_1day   = linspace(0,24*3600,10000); % 1 day
t_10days = linspace(0,10*24*3600,50000); % 10 days

%non-repeating groundtrack on given parameters 
[lat_1o,lon_1o] = groundtrack(kep0,t_1orbit,t0,G0,'XYZ'); % groundtrack (lat, lon) with initial Keplerian elements, time span, initial time, and initial Greenwich longitudein ECI
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
plot3(state_cart(:,1),state_cart(:,2),state_cart(:,3),'r','LineWidth',2.5);
title('Unperturbed orbit','Interpreter','latex','FontSize',15)
xlabel('X [km]','Interpreter','latex');
ylabel('Y [km]','Interpreter','latex');
zlabel('Z [km]','Interpreter','latex');
grid on;
axis equal;

%Repeating groundtrack 

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
t_korbit_r = linspace(0,2*k*T_rep,k*10000); % 14 orbits time span

[lat_1o_un_r,lon_1o_un_r] = groundtrack(kep_un_r,t_1orbit_r,t0,G0,'XYZ');
[lat_ko_un_r,lon_ko_un_r] = groundtrack(kep_un_r,t_korbit_r,t0,G0,'XYZ');

groundtrack_plotting(lon_1o_un_r,lat_1o_un_r,'Unperturbed Groundtrack - repeating orbit for 1 period');
groundtrack_plotting(lon_ko_un_r,lat_ko_un_r,'Unperturbed Groundtrack - repeating orbit for k=14 period');

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

groundtrack_plotting(lon_ko_un_r,lat_ko_un_r,'Perturbed Groundtrack - repeating orbit for 14 orbits');
groundtrack_plotting(lon_ko_pt_r,lat_ko_pt_r,'',length(findobj('type','figure')),{'DisplayName','Perturbed GT'});

% Orbit propagation in Cartesian Coordinates
tic
N_days = 180; % 180 days = 6 months (2 moon periods = 2 months) -> enough to see fully its perturbations 
tspan = linspace(0, N_days * 24 * 3600, N_days * 1000); 
npoints = N_days * 1000;  
func_ode = @(t, s) twoBP(s, pert(t0 + t/24/3600, s, 'XYZ'), mu_E, 'XYZ'); 
[~, car_pert] = ode113(func_ode, tspan, [r0; v0], options); 
kep_car = zeros(size(car_pert));

% Computing the Keplerian elements for comparison
 for i = 1:length(car_pert)
     s_i = car_pert(i, 1:3)';
     v_i = car_pert(i, 4:6)';
     kep_i = car2kep(s_i, v_i, mu_E);
     kep_car(i, :) = kep_i;
 end

% Orbit propagation in Keplerian elements

func_ode = @(t,s) twoBP(s,pert(t0+t/24/3600,s,'RSW',1),mu_E,'RSW');
[~,kep_rsw_pert] = ode113(func_ode,tspan,kep0,options);

   
% twoBP finds ds

[~,kep_rsw_pert] = ode113(func_ode,tspan,kep0,options); %data vector in gauss coordinates
[~,kep_rsw] = ode113(@(t,s) twoBP(s,[0;0;0],mu_E,'RSW'),...
    tspan,kep0,options);
[~,kep_rsw_j2] = ode113(@(t,s) twoBP(s,pert(t0+t/24/3600,s,'RSW','J2',1),mu_E,'RSW'),...
    tspan,kep0,options);
[~,kep_rsw_moon] = ode113(@(t,s) twoBP(s,pert(t0+t/24/3600,s,'RSW','MOON',1),mu_E,'RSW'),...
    tspan,kep0,options);

titles = {'Semir-major axis','Eccentricity','inclination',...      
    'RA of ascending node','Argument of perigee','True anomaly','Interpreter','latex','FontSize',15};
ylabels = {'a [km]','e [-]','i [deg]','\Omega [deg]','\omega [deg]','\theta [deg]','Interpreter','latex'};

for i = 1:6
    subplot(3,2,i);
    if i <= 2
    plot(tspan/24/3600,kep_rsw_pert(:,i),'Color','b','DisplayName','Moon+J2');
    xlim([0,N_days]);
    hold on
    %plot(tspan/24/3600,kep_rsw_j2(:,i),'Color','r','DisplayName','J2');
    %plot(tspan/24/3600,kep_rsw_moon(:,i),'Color','m','DisplayName','Moon');
    plot(tspan/24/3600,kep_rsw(:,i),'Color','g','DisplayName','No perturbation');
    grid on
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]','Interpreter','latex');
    ylabel(ylabels{i});
    elseif i >= 3
    plot(tspan/24/3600,rad2deg(kep_rsw_pert(:,i)),'Color','b','DisplayName','Moon+J2');
    xlim([0,N_days]);
    hold on
    %plot(tspan/24/3600,rad2deg(kep_rsw_j2(:,i)),'Color','r','DisplayName','J2');
    %plot(tspan/24/3600,rad2deg(kep_rsw_moon(:,i)),'Color','m','DisplayName','Moon');
    plot(tspan/24/3600,rad2deg(kep_rsw(:,i)),'Color','g','DisplayName','No perturbation');
    grid on
    title(titles{i},'Interpreter','latex','FontSize',15);
    xlabel('Time [days]','Interpreter','latex');
    ylabel(ylabels{i});
    end
end

toc






