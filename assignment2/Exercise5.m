format long g
disp('2024-10-20 is CEST!');
disp('UTC="2024-10-20,00:00:00"');

UTC = [2024, 12, 1, 12, 0, 0];
dUT1_ms = 0.0535314; 

UT1_seconds = UTC(6) + dUT1_ms;
UT1 = UTC;
UT1(6) = UT1_seconds; 

[UT1_JD, UT1_MJD] = gre2jd(UT1(1), UT1(2), UT1(3), UT1(4), UT1(5), UT1(6));
disp('UTC Time:');
disp(UTC);
disp('UT1 Time:');
disp(UT1);
disp('UT1 Julian Date:');
disp(UT1_JD);
disp('UT1 Modified Julian Date:');
disp(UT1_MJD);
% a
T = UT1_JD - 2451545.0; 
ERA = 2*pi*(0.7790572732640+1.00273781191135448*T);
ERA=rad2deg(ERA);
ERA=mod(ERA,360)
[deg,minutes,seconds]=decimalToDMS(ERA);
% Display result
fprintf('ERA: %d° %d\'' %d"\n', deg, minutes, seconds);
%b
t=(UT1_JD-2451545.0)/36525;
GMST=(F(UT1_JD)*86400+24110.54841-86400/2+8640184.812866*t+0.093104*t*t-6.2e-6*t*t*t)/3600;
GMST = mod(GMST, 24);
delta_psi=0.001096;
theta=(84381.448-46.8150*t-5.9*10e-4*(t^2)+1.813*10e-3*(t^3))*pi/648000;
omega=(450160.28-482890.539*t+7.455*(t^2)+0.008*(t^3))*pi/648000+2*pi*F(-5*t);
Eq_e=delta_psi*cos(theta)+(2.64*10e-3*sin(omega)+6.3*10e-5*sin(2*omega))*pi/648000;
Eq_e=Eq_e.*12/pi;
GAST=GMST+Eq_e;
GAST = mod(GAST, 24);
[deg,minutes,seconds]=decimalToDMS(ERA);
fprintf('GST: %02d h %02d m %02d s\n', deg, minutes, seconds);

function [jd, mjd] = gre2jd(yyyy, mm, dd, hour, minute, second)
    fd = hour / 24 + minute / 1440 + second / 86400;
    my = fix((mm - 14) / 12);
    jd = fix((1461 * (yyyy + 4800 + my)) / 4) ...
        + fix((367 * (mm - 2 - 12 * my)) / 12) ...
        - fix((3 * fix((yyyy + 4900 + my) / 100)) / 4) ...
        + dd - 32075.5 + fd;
    mjd = jd - 2400000.5;
end

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
    angle = mod(angle, 360);
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
function Fx=F(x)
    Fx=x-fix(x);
end

end
