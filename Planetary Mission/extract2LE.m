function data = extract2LE(filename,wrap)
% Function to read the orbital elements from a TLE file. It also computes
% the true anomaly and the semi-major axis from the data.
% 
% INPUT:
%  filename [char]  Name/path of the file containing the TLE data
%  wrap [logical]   (Optional) If you want to wrap the angles between
%                   [0,360] it must be a logical true. To keep values
%                   unwraped it must be a logical false.
%                   By default it's false.
%
% OUTPUT
% data [nx7]        Matrix with 7 columns and 1 line for each data point in
%                   the TLE file. Each column represents one element:
%                   Time in MJD2000, Semi-major axis, Eccentricity, RAAN,
%                   Argument of Perigee, True Anomaly.
%                   Units: Days, km, [-], deg, deg, deg, deg.

if nargin == 1
    wrap = false;
end

fclose('all');
fid = fopen(filename,'r');
data = zeros(1,7); 
ind = 1;
muE = astroConstants(13);
while true
   line =  fgetl(fid);
   if line ~= -1
       if line(1) == '1'
         
           year = str2double(strcat('20',line(19:20)));
           day = str2double(line(21:32));
           time = date2mjd2000([year 1 1 0 0 0]) + day; % in MJD2000
           
           
           if ind == 1
               data(ind,1) = time;
           elseif time ~= data(ind-1,1)
               data(ind,1) = time;
           end
       elseif line(1) == '2'
        
           inc = str2double(line(9:16));
           RA = str2double(line(18:25));
           e = str2double(strcat('0.',line(27:33)));
           omega = str2double(line(35:42));
           M = deg2rad(str2double(line(44:51)));
           n = str2double(line(53:63));
           n_rev = str2double(line(64:68));
         
           E = fzero(@(EE) EE - e*sin(EE) - M,M+(e*sin(M)/(1-sin(M+e)+sin(M))));
           theta = 2*atan2(sqrt((1+e)/(1-e))*sin(E/2),cos(E/2));
           theta = n_rev*360 + rad2deg(theta);
       
           a = ((24*3600/n/2/pi)^2*muE)^(1/3);
           
           if ind == 1
               data(ind,2:end) = [a,e,inc,RA,omega,theta];
              
               ind = ind+1;           
           elseif time ~= data(ind-1,1)
               data(ind,2:end) = [a,e,inc,RA,omega,theta];
             
               ind = ind+1;
           end
       end
   else 
       break     
   end
end
fclose(fid);


if ~wrap
    nrev_RAAN = 0;
    nrev_omega = 0;
    RAAN_old = data(1,5);
    omega_old = data(1,6);
    
    for i = 2:length(data(:,1))
       
        RAAN_i = data(i,5);
        if RAAN_i < 5 && RAAN_old > 355 
            nrev_RAAN = nrev_RAAN + 1;
        elseif RAAN_i > 355 && RAAN_old < 5 
            nrev_RAAN = nrev_RAAN - 1;
        end
        RAAN_old = RAAN_i;
        data(i,5) = RAAN_i + 360*nrev_RAAN;
        
        
        omega_i = data(i,6);
        if omega_i < 5 && omega_old > 355
            nrev_omega = nrev_omega + 1;
        elseif omega_i > 355 && omega_old < 5
            nrev_omega = nrev_omega - 1;
        end
        omega_old = omega_i;
        data(i,6) = omega_i + 360*nrev_omega;  
    end
    
elseif wrap
  
    data(:,end) = wrapTo2Pi(data(:,end));
end
end
