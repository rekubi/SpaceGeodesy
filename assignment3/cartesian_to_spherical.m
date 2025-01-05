function [phi, lambda, r]=cartesian_to_spherical(x,y,z)
    % Robustness
    if ~isscalar(x)
        error('x is not a scalar')
    end
    if ~isscalar(y)
        error('y is not a scalar')
    end
    if ~isscalar(z)
        error('z is not a scalar')
    end
    r = sqrt(x^2 + y^2 + z^2);
    lambda = atan2d(y,x);
    phi = atan2d(z,sqrt(x^2 + y^2));