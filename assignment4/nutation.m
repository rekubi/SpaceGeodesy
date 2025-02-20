function [N] = nutation(JD)
    % Robustness
    if ~isscalar(JD) || JD < 2451545.0
        error('The date given is not a valid date');
    end
    dT = JD - 2451545.0;
    T = dT / 36525;
    f1 = 125 - 0.05295*dT;
    f2 = 200.9 - 1.97129*dT;
    
    delta_psi = -0.0048 * sin(f1) - 0.0004 * sin(f2);
    delta_eps = 0.0026 * cos(f1) - 0.0002 * cos(f2);
    eps_zero = 84381.448 - 46.8150*T;

    R1 = rot3d(-eps_zero - delta_eps, 1);
    R2 = rot3d(-delta_psi, 3);
    R3 = rot3d(eps_zero, 1);
    N = R1 * R2 * R3;  