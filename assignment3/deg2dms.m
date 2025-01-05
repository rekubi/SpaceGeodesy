function [deg, min, sec] = deg2dms(angle)
    %% decimalToDMS Converts an angle in decimal degrees to degrees, 
    %% minutes, and seconds with proper sign handling.

    % usage DMS_angle = decimalToDMS(angle) 
    % input:
    % angle angle to be converted [deg.dec]
    %
    % output:
    % DMS_angle angle in [degree, minute, second]
    
    % Extract the sign of the input
    angleSign = sign(angle);
    angleDegree = abs(angle)
    
    % Compute degrees, minutes, and seconds
    deg = floor(angleDegree);                % Integer degrees
    remainder = (angleDegree - deg) * 60;    % Remaining fraction in minutes
    min = floor(remainder);                % Integer minutes
    sec = (remainder - min) * 60;          % Remaining fraction in seconds (decimal)

    % Apply the sign to the largest non-zero component
    if deg ~= 0
        deg = angleSign * deg;
    elseif min ~= 0
        min = angleSign * min;
    else
        sec = angleSign * sec;
    end
end