function dy = ode_2bp_pert( ~, y, mu )
% ode_2bp_pert - ODE system for the two-body problem perturbated (Keplerian motion)
%
% PROTOTYPE
%
% dy = ode_2bp( t, y, mu )
%
% INPUT:
%   t[1]    Time (can be omitted, as the system is autonomous) [T]
%   y[6x1]  State of the body ( rx, ry, rz, vx, vy, vz) [ L, L/T ]
%   mu[1]   Gravitational parameter of the primary [L^3/T^2]
%
% OUTPUT:
%   dy[6x1] Derivative of the state [ L/T^2, L/T^3 ]
%
% CONTRIBUTORS:
% Juan Luis Gonzalo Gomez
%
% VERSIONS
% 2018-09-26: First version
%
% ---------------------------------------------------------------------

% Position and velocity
r = y(1:3);
v = y(4:6);

% Distance from the primary
rnorm = norm(r);

% Perturbation due to the second zonal harmonic
R_e = astroConstants(23);
J2 = 0.00108263;
X = r(1); Y = r(2); Z = r(3);
aj2x = 3/2 * J2 * mu * R_e^2 / rnorm^4 * (X/rnorm * (5*Z^2/rnorm^2 - 1));
aj2y = 3/2 * J2 * mu * R_e^2 / rnorm^4 * (Y/rnorm * (5*Z^2/rnorm^2 - 1));
aj2z = 3/2 * J2 * mu * R_e^2 / rnorm^4 * (Z/rnorm * (5*Z^2/rnorm^2 - 3));
aj2 = [aj2x; aj2y; aj2z];

% Set the derivatives of the state
dy = [ v
        (-mu/rnorm^3)*r + aj2];

end