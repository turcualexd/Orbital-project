function groundtrack_plotting(long,lat,fig_title,n_fig,fig_param)
% Function that plots the groundtrack path of the satellite.
%
% INPUT
% long [n]          Vector with the longitudes of the groundtrack path[rad]
% lat [n]           Vector with the latitudes of the groundtrack path [rad]
% fig_title [char]  (Optional) Title of the figure.
% n_fig [1]         (Optional) Number of the figure that will be created.
%                   If the value is not provided, then a new figure is
%                   created. This argument is useful for plotting two
%                   different groundtracks on the same figure.
%                   If n_fig matches with an existing figure, it will
%                   keeps the previous plot and add the new one.
% fig_param [cell]  (Optional) Additional parameters for the plot. Must be
%                   a cell structure as {Param1,Value1,Param2,Value2,...}
%
% OUTPUT
% This function doesn't returns anything, but a new figure is created

if nargin <= 3
   n_fig = length(findobj('type','figure'))+1; 
end

% open the map of the Earth for the background of the plots
earth_bg = imread('world_map_2.jpg');

% add a NaN everytime longitude goes from 180 to -180 or from -180 to 180
n = length(long)*2;
new_long = zeros(1,n);
new_lat = zeros(1,n);
ii = 0;
for i = 1:length(long)
   if i == 1 % for i = 1 there's no check to be done
       new_long(i) = long(i);
       new_lat(i) = lat(i);       
   else % for i > 1
       if long(i-1) > deg2rad(160) && long(i) < -deg2rad(160) % if we go from ~pi to ~-pi
           % add NaN
           new_long(i+ii) = NaN;
           new_lat(i+ii) = NaN;
           ii = ii + 1; % increase counter
           % add the values after the NaN
           new_long(i+ii) = long(i);
           new_lat(i+ii) = lat(i);
       elseif long(i-1) < -deg2rad(160) && long(i) > deg2rad(160) % if we go from ~-pi to ~pi
           % add NaN
           new_long(i+ii) = NaN;
           new_lat(i+ii) = NaN;
           ii = ii + 1; % increase counter
           % add the values after the NaN
           new_long(i+ii) = long(i);
           new_lat(i+ii) = lat(i);
       else % otherwise, just adds the values
           new_long(i+ii) = long(i);
           new_lat(i+ii) = lat(i);
       end
       
       if i == length(long) % at the end, remove the final zeros
           lat = new_lat(1:i+ii);
           long = new_long(1:i+ii);
       end
   end
end

if n_fig > length(findobj('type','figure')) % first plot
    % initiate the figure
    figure(n_fig);
    
    % plot earth image as backgroung
    imagesc([-180 180], [-90 90], flip(earth_bg,1));
    set(gca,'ydir','normal');
    set(gca,'GridColor',[1,1,1]);
    hold on;

    % plot groundtrack
    plot(rad2deg(long),rad2deg(lat),'Color','r','LineWidth',1.2,'DisplayName','Groundtrack');

    % plot initial and final positions
    scatter(rad2deg(long(1)),rad2deg(lat(1)),80,'r','filled',...
        'Marker','o','LineWidth',2,'DisplayName','Start');
    scatter(rad2deg(long(end)),rad2deg(lat(end)),80,'r','filled',...
        'Marker','s','LineWidth',2,'DisplayName','End');

    % set properties of the axis
    axis on;
    grid on;
    % legend;
    if nargin > 2
        title(fig_title,'Interpreter','latex','FontSize',15);
    end
    xlabel('Longitude [deg]','Interpreter','latex');
    ylabel('Latitude [deg]','Interpreter','latex');

    xticks(-180:30:180);
    yticks(-90:30:90);
    xticklabels({'-180\circ','-150\circ','-120\circ','-90\circ','-60\circ',...
        '-30\circ','0\circ','30\circ','60\circ','90\circ','120\circ',...
        '150\circ','180\circ'})
    yticklabels({'-90\circ','-60\circ','-30\circ','0\circ','30\circ',...
        '60\circ','90\circ'});
    
elseif n_fig <= length(findobj('type','figure')) % plot in an existing figure
    % initiate the figure
    figure(n_fig);
    hold on;
    
    % plot groundtrack
    plot(rad2deg(long),rad2deg(lat),'Color','g','LineWidth',1.2,fig_param{:});
    % plot initial and final positions
    scatter(rad2deg(long(1)),rad2deg(lat(1)),60,'g','filled',...
        'Marker','o','LineWidth',2,'DisplayName','Start');
    scatter(rad2deg(long(end)),rad2deg(lat(end)),60,'g','filled',...
        'Marker','s','LineWidth',2,'DisplayName','End');
    % legend;
end
end