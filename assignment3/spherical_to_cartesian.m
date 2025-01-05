function [x, y, z]=spherical_to_cartesian(phi, lam, r)
    % Robustness
    if ~isscalar(phi)
        error('phi is not a scalar')
    end
    if ~isscalar(lam)
        error('lam is not a scalar')
    end
    if ~isscalar(r)
        error('r is not a scalar')
    end
    x = r * cosd(lam) * cosd(phi);
    y = r * sind(lam) * cosd(phi);
    z = r * sind(phi);