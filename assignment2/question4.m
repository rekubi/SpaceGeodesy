
function [deg, min, sec] = decimalToDMS(angle)
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
    absDegree = abs(angle);
    
    % Compute degrees, minutes, and seconds
    deg = floor(absDegree);                % Integer degrees
    remainder = (absDegree - deg) * 60;    % Remaining fraction in minutes
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

function result = isDifferentSign(mainSign, secondarySign)
    %% Check that user input are coherent in sign
    % input:
    % mainSign sign of the largest non-zero digit -1 || +1
    % secondarySign sign of the non-largest non-zero digit -1 || +1
    % 
    % output:
    % result false if the secondary sign 0 or if the sign are equal 
    % true otherwise [bool]
    %
    if secondarySign == 0
        result = false;
    else 
        result = mainSign ~= secondarySign
    end
end



function decimalDegree = DMSToDecimal(deg, min, sec)
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
        if isDifferentSign(angleSign, sign(min)) || isDifferentSign(angleSign, sign(sec))
            error('All non-zero inputs (deg, min, sec) must agree in sign.');
        end
    elseif min ~= 0
        angleSign = sign(min);
        if isDifferentSign(angleSign, sign(sec))
            error('All non-zero inputs (deg, min, sec) must agree in sign.');
        end
    else
        angleSign = sign(sec);
    end

    % Compute the absolute value of decimal degrees
    absDegree = abs(deg) + abs(min) / 60 + abs(sec) / 3600;
    
    % Apply the sign
    decimalDegree = angleSign * absDegree;
end

%[deg, min, sec] = decimalToDMS(-123.456);
%[deg, min, sec] = decimalToDMS(0);
%[deg, min, sec] = decimalToDMS(18);
%[deg, min, sec] = decimalToDMS(18.01);
[deg, min, sec] = decimalToDMS(0.0167);
%[deg, min, sec] = decimalToDMS(0.0001);
%[deg, min, sec] = decimalToDMS(0.1);

%decimalDegree = DMSToDecimal(0, 0, 0)
%decimalDegree = DMSToDecimal(0, 1, 0)
%decimalDegree = DMSToDecimal(0, 0, 1)
%decimalDegree = DMSToDecimal(-1, 0, 1)
decimalDegree = DMSToDecimal(0, 1, 0)
%decimalDegree = DMSToDecimal(0, -1, 1)
%decimalDegree = DMSToDecimal(0, 0, -36)