function acc = pert(time,state,fr,perturb,kep)


muE = astroConstants(13);   % planetary constant of Earth - [kg3/s2]
R_E = astroConstants(23);   % radius of Earth
muM = astroConstants(20);   % planetary constant of Moon - [kg3/s2]
J2 = 0.001082626925639;     % J2 perturbation parameter

% By default generates both perturbations
if nargin < 4
    perturb = 'BOTH';
    kep = 0;
elseif ~ischar(perturb)
    kep = perturb;
    perturb = 'BOTH';
elseif ischar(perturb) && nargin == 4
    kep = 0;
end

%if input is Keplerian elements
if nargin > 3
    if kep
        [r,v] = kep2car(state,muE);
        state = [r;v];
    end
end


r_sc = state(1:3);  % position of the spacecraft - radius Earth-Spacecraft
v_sc = state(4:6);  % velocity of the spacecraft 

%J2 perturbation on Cartesian coordinates
r_norm = norm(r_sc);
aJ2 = 3*J2*muE*R_E^2/(2*r_norm^4);
aJ2 = aJ2*[r_sc(1)/r_norm*(5*(r_sc(3)/r_norm)^2-1);
           r_sc(2)/r_norm*(5*(r_sc(3)/r_norm)^2-1);
           r_sc(3)/r_norm*(5*(r_sc(3)/r_norm)^2-3)];

%Moon perturbation in Cartesian Coordinates
[r_moon,~] = ephMoon(time); %radius E-Moon
a_moon = muM*((r_moon'-r_sc)/norm(r_moon'-r_sc)^3 - r_moon'/norm(r_moon)^3); %r_moon'-r_sc = radius spacecraft-Moon

%Sum of the perturbations 
if strcmp(perturb,'BOTH')
    acc = a_moon + aJ2;
elseif strcmp(perturb,'MOON')
    acc = a_moon;
elseif strcmp(perturb,'J2')
    acc = aJ2;
end

% Change of coordinates, if necessary
if strcmp(fr,'RSW') || strcmp(fr,'TNH') % to r theta h fr
    [kep] = car2kep(r_sc, v_sc,muE);
    a = kep(1); e = kep(2); i = kep(3);OM = kep(4); om = kep(5); theta = kep(6);

    R3_Ohm = [cos(OM) sin(OM) 0;-sin(OM) cos(OM) 0;0 0 1];
    R1_i = [1 0 0;0 cos(i) sin(i);0 -sin(i) cos(i)];
    R3_wt = [cos(om+theta) sin(om+theta) 0; -sin(om+theta) cos(om+theta) 0;0 0 1];
    acc = R3_wt*R1_i*R3_Ohm*acc;
    if strcmp(fr,'TNH') % to tangential normal out-of-plane fr
        fpa = atan2(e*sin(theta),1+e*cos(theta));
        R = [cos(pi/2-fpa) sin(pi/2-fpa) 0;-sin(pi/2-fpa) cos(pi/2-fpa) 0;0 0 1];
        acc = R*acc;
    end
end
end