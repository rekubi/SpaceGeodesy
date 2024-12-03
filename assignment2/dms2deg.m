function decimalDegree = dms2deg(deg, min, sec)
    %% DMSToDecimal Converts an angle in degrees, 
    %% minutes, and seconds to decimal degrees proper sign handling.

    % usage DMS_angle = DMSToDecimal(angle) 
    % input:
    % angle angle to be converted in [degree, minute, second]
    %
    % output:
    % angle angle in [deg.dec]
    
    % Determine the sign from the largest non-zero unit
    if deg ~= 0
        angleSign = sign(deg);
    elseif min ~= 0
        angleSign = sign(min);
    else
        angleSign = sign(sec);
    end

    % Compute the absolute value of decimal degrees
    absDegree = abs(deg) + (abs(min) / 60) + (abs(sec) / 3600);
    
    % Apply the sign
    decimalDegree = angleSign * absDegree;
end
