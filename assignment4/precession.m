function [P] = precession(JD)
    % Robustness
    if ~isscalar(JD) || JD < 2451545.0
        error('The date given is not a valid date');
    end
    dT = JD - 2451545.0;
    T = dT / 36525;
    zeta = 2306.2181 * T + 0.30188 * T^2;
    z = 2306.2181 * T + 1.09468 * T^2;
    theta = 2004.3109 * T - 0.42665 * T^2;
    zeta = zeta * (pi / (180 * 3600));
    z = z * (pi / (180 * 3600));
    theta = theta * (pi / (180 * 3600));
    R1 = rot3d(-z, 3);
    R2 = rot3d(theta, 2);
    R3 = rot3d(-zeta, 3);
    
    P = R1 * R2 * R3;  