function NEO_3D(r,n)


%% Default Input

% Set the default value for the Earth radius in case of no inputs.
if nargin < 2
    n = 1;
end
Rt = 31.66 / 2 * n / astroConstants(2);
r = r / astroConstants(2);

%%  Load the Earth image from a website
%Earth_image = 'https://www.solarsystemscope.com/textures/download/8k_earth_daymap.jpg';
Earth_image = 'NEO.jpg';

%% Figure

% Create the figure
hold on;
grid on;

% Set the axes scale equal
axis equal;

% Put the axes labels
xlabel('X [AU]', 'FontSize', 15);
ylabel('Y [AU]', 'FontSize', 15);
zlabel('Z [AU]', 'FontSize', 15);

% Set initial view
view(120,30);

%% Create Earth surface as a wireframe

% Define the number of panels to be used to model the sphere 
npanels = 180;  

% Create a 3D meshgrid of the sphere points using the ellipsoid function
[x, y, z] = ellipsoid(r(1), r(2), -r(3), Rt, Rt, Rt, npanels);

% Create the globe with the surf function
globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 'none');

%% Texturemap the globe

% Load Earth image for texture map
cdata = imread(Earth_image);

% Set the transparency of the globe: 1 = opaque, 0 = invisible
alpha = 1; 

% Set the 'FaceColor' to 'texturemap' to apply an image on the globe, and
% specify the image data using the 'CData' property with the data loaded 
% from the image. Finally, set the transparency and remove the edges.
set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');

end