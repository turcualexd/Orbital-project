function [lat,long] = groundtrack(s0,tspan,t0,G0,fr,perturb,wrap)

muE = astroConstants(13);   
w_E = deg2rad(15.04)/3600;  

if nargin < 6
    perturb = false;
    wrap = true;
elseif nargin < 7
    wrap = true;
end


if strcmp(fr,'XYZ')
    if all(size(s0) == [3 2])
        r0 = s0(:,1);
        v0 = s0(:,2);
    elseif all(size(s0) == [1 6])
        [r0,v0] = kep2car(s0,muE);
    end
    s0 = [r0;v0];
    
elseif strcmp(fr,'RSW') || strcmp(fr,'TNH')
    if all(size(s0) == [3 2])
        s0 = car2kep(s0(:,1),s0(:,2),muE);
    end
end

opt_ode = odeset('RelTol',1e-13,'AbsTol',1e-13);


if strcmp(perturb,'J2')
    f_ode = @(t,s) twoBP(s,pert(t0+t/24/3600,s,fr,perturb),muE,fr);
elseif strcmp(perturb,'MOON')
    f_ode = @(t,s) twoBP(s,pert(t0+t/24/3600,s,fr,perturb),muE,fr);
elseif strcmp(perturb,'BOTH')
    f_ode = @(t,s) twoBP(s,pert(t0+t/24/3600,s,fr,perturb),muE,fr);
elseif ~perturb
    f_ode = @(t,s) twoBP(s,[0;0;0],muE,fr);
end


[time,state] = ode113(f_ode, tspan, s0, opt_ode);

if strcmp(fr,'TNH') || strcmp(fr,'RSW')
    R_vec = zeros(length(tspan),3);
    V_vec = zeros(length(tspan),3);
    for i = 1:length(tspan)
       [R_vec(i,:),V_vec(i,:)] = kep2car_2_0(state(i,:),muE); 
    end
elseif strcmp(fr,'XYZ')
    R_vec = state(:,1:3);
    V_vec = state(:,4:6);  
end

theta_G = G0 + w_E.*(time - tspan(1));
      

delta = zeros(length(R_vec(:,1)),1);
alpha = zeros(length(R_vec(:,1)),1);

for i = 1:length(R_vec(:,1))
    rr = R_vec(i,:);
    delta(i) = asin(rr(3)/norm(rr));
    alpha(i) = acos(rr(1)/norm(rr)/cos(delta(i)));
    if rr(2) <= 0
        alpha(i) = 2*pi - alpha(i);
    end
end

lat = delta;
long = alpha - theta_G;


if wrap
   lat = wrapToPi(lat);
   long = wrapToPi(long);
end

end