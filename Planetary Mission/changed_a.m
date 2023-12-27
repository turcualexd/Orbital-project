function a = changed_a(k,m,mu,Te)
% Function to compute the recquired semi-major axis to achieve a repeating
% unperturbed groundtrack.
%
% INPUTS
% k [1]     Repeating orbit after k periods of satellite
% m [1]     Repeating orbit after m periods of the planet
% mu [1]    Gravitational parameter of the central body [L^3/T^2]
% Te [1]    Period of planet's rotation around it's own axis [T]
%
% OUTPUT
% a [1]     Required semi-major axis to have a repeating groundtrack with
%           ratio k:m. [L]



a = (((Te*m/k/2/pi)^2)*mu)^(1/3);
end

