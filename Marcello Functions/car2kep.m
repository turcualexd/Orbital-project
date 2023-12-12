function [a,e,i,Om,om,theta] = car2kep(rr,vv,   mu)

r = norm(rr);
v = norm(vv);
k = [0 0 1]';

a = -mu / (v^2 - 2*mu/r);

hh = cross(rr,vv);
h = norm(hh);

ee = cross(vv,hh)/mu - rr/r;

e = norm(ee);

if e == 0

    ee = [1; 0; 0];

end

i = acos(hh(3)/h);

if i == 0

    i =eps;

end

if i == 0

    N = [1; 0; 0];

else
    N = cross(k,hh) / norm(cross(hh,k));
end

Om = acos(N(1));
if N(2) < 0
    Om = 2*pi - Om;
end

om = acos(dot(N,ee)/e);
if ee(3) < 0
    om = 2*pi - om;
end

theta = acos(dot(rr,ee)/(r*e));
if dot(rr,vv) < 0
    theta = 2*pi - theta;
end




end

