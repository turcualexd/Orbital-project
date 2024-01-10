function v_rot = rodrigues(v, u, delta)

%---------------Simple implementation of Rodrigues formula-----------------
%
% This function rotates the vector v around the direction pointed by vector
% u of an angle of delta.
%
%--------------------------------------------------------------------------
%
% INPUT:
% v               [3x1]: vector to rotate
% u               [3x1]: vector to define rotation direction
% delta             [1]: angle value to rotate, in rad
%
% OUTPUT:
% v_rot           [3x1]: rotated vector
%
%--------------------------------------------------------------------------
%
% AUTHOR: Alex Cristian Turcu
%
%--------------------------------------------------------------------------

v_rot = v * cos(delta) + cross(u, v) * sin(delta) + u * dot(u, v);