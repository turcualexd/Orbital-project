function ds = twoBP(state,a_dist,mu,fr)

% Function used to model the ODE of the Two Body Problem, both for the
% perturbed and unperturbed cases.
%
% INPUTS
% state [6x1]   Initial state. Can be a Cartesian state vector in
%               the format [r;v] where r is the position and
%               v is the initial velocity. [L] and [L/T].
%               Can also be a vector with the initial
%               Keplerian elements [Semi-major axis, eccentricity,
%               inclination, RAAN, Argument of perigee, True anomaly].
%               The units are [[L], [-], [rad], [rad], [rad], [rad]].
%               If frame=='XYZ', it must be [r;v] vector.
%               If frame=='TNH' or frame=='RSW', it must be Keplerian
%               elements vector.
% a_dist [3x1]  Disturbing acceleration in the respective reference
%               frame. [L/T^2].
% mu [1]        Gravitational parameter of the central body [L^3/T^2]
% fr [char]     Reference frame in which the two body problem ODE will be 
%               computed. Must be:
%                   - 'XYZ': Earth centered Inertial.
%                   - 'RSW': Radial transversal out-of-plane.
%                   - 'TNH': Tangential normal out-of-plane.
%
% OUTPUT
% ds [6x1]      Derivatives of the state vector with respect to time in
%               it's respective reference frame (same as input).
%               If in XYZ frame, the units are:
%               [L/T];[L/T];[L/T];[L/T^2];[L/T^2];[L/T^2]
%               If in RSW or TNH frame, units are:
%               [L/T];[T^-1];[rad/T];[rad/T];[rad/T];[rad/T]

if strcmp(fr,'XYZ')
    % slices the variables
    r = state(1:3);
    v = state(4:6);
    % computes the norm of r
    r_norm = norm(r);
    % output vector
    ds = [v ; -mu/(r_norm^3)*r + a_dist];
    
elseif strcmp(fr,'RSW')
    % Unwrap the values from the keplerian vectors
    a = state(1);
    e = state(2);
    i = state(3);
    % Ohm = kep(4);
    omega = state(5);
    theta = state(6);

    % Unwrap the disturbance
    ar = a_dist(1);
    as = a_dist(2);
    aw = a_dist(3);

    % compute auxiliary values
    b = a*sqrt(1-e^2);
    p = b^2/a;
    h = sqrt(p*mu);
    r = p/(1 + e*cos(theta));

    % compute the derivatives
    da = 2*a^2/h*(e*sin(theta)*ar + p/r*as);
    de = (p*sin(theta)*ar + ((p+r)*cos(theta) + r*e)*as)/h;
    di = r*cos(theta+omega)*aw/h;
    dOhm = r*sin(theta+omega)*aw/h/sin(i);
    domega = (-p*cos(theta)*ar + (p+r)*sin(theta)*as)/h/e - dOhm*cos(i);
    dtheta = h/r^2 + (p*cos(theta)*ar - (p+r)*sin(theta)*as)/e/h;

    ds = [da;de;di;dOhm;domega;dtheta];
elseif strcmp(fr,'TNH')
    % Unwrap the values from the keplerian vectors
    a = state(1);
    e = state(2);
    i = state(3);
    % Ohm = kep(4);
    omega = state(5);
    theta = state(6);

    % Unwrap the disturbance
    at = a_dist(1);
    an = a_dist(2);
    ah = a_dist(3);

    % compute auxiliary values
    b = a*sqrt(1-e^2);
    p = b^2/a;
    h = sqrt(p*mu);
    r = p/(1 + e*cos(theta));
    nu = sqrt(2*mu/r - mu/a);

    % compute the derivatives
    da = 2*a^2*nu/mu*at;
    de = (2*(e + cos(theta))*at - r*sin(theta)*an/a)/nu;
    di = r*cos(theta+omega)*ah/h;
    dOhm = r*sin(theta+omega)*ah/h/sin(i);
    domega = (2*sin(theta)*at + (2*e + r*cos(theta)/a)*an)/e/nu - dOhm*cos(i);
    dtheta = h/r^2 - (2*sin(theta)*at + (2*e + r*cos(theta)/a)*an)/e/nu;

    ds = [da;de;di;dOhm;domega;dtheta];
end

end