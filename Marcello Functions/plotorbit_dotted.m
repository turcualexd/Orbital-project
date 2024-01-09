function plotorbit_dotted(a, e, i, OM, om, th0, thf, dth, mu, color)

if th0 <= thf


theta = th0:dth:thf;

else

    theta = [th0:dth:2*pi,0:dth:thf];

end

R = zeros(length(theta), 3);

for t = 1:length(theta)

    th = theta(t); 

    [rr, ~] = par2car(a, e, i, OM, om, th, mu); 

    R(t, :) = rr; 

end

plot3(R(:, 1), R(:, 2), R(:, 3), '--','Color',color, 'LineWidth',2)

return