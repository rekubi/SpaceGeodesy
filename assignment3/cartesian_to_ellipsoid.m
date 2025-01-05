function [B,L,h]=cartesian_to_ellipsoid(x,y,z, model)
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
    if ~isstring(model)
        error('model argument needs to be a string')
    end
    if ~strcmp(model,"BESSEL") & ~strcmp(model,"GRS80") & ~strcmp(model,"WGS84")
        error('The reference elipsoidal model is incorrect or not implement, please use either "BESSEL" , "GRS80" or "WGS84"')
    end

    if strcmp(model,"BESSEL")
        % Initialize BESSEL
        a = 6377397.155;
        b = 6356078.963;
        f = (a-b)/a;
    end

    if strcmp(model,"GRS80")
        % Initialize GRS80
        a = 6378137;
        f = 1/298.257222101;
    end

    if strcmp(model,"WGS84")
        % Initialize WGS84
        a = 6378137;
        f = 1/298.257223563;
    end

    % Iterative method
    e2 = 2 * f - f ^ 2;
    ep2 = e2 / (1 - e2); % square of second eccentricity
    b = a * (1 - f); % semi-minor axis
    L = atan2(y,x); % geodetic longitude
    p = sqrt(abs(x).^2+abs(y).^2);% distance from z-axis
    beta = atan2(z, (1 - f) * p); % parametric latitude start value
    B = atan2(z + b * ep2 * sin(beta).^3,...
    p - a * e2 * cos(beta).^3);
    betaNew = atan2((1 - f)*sin(B), cos(B));
    i_ter = 0;
    while any(beta(:) ~= betaNew(:)) && i_ter < 5
    beta = betaNew;
    B = atan2(z + b * ep2 * sin(beta).^3,...
    p - a * e2 * cos(beta).^3);
    betaNew = atan2((1 - f)*sin(B), cos(B));
    i_ter = i_ter + 1;
    end
    % calculate ellipsoidal height from the final value of latitude
    sinB = sin(B);
    N = a ./ sqrt(1 - e2 * sinB.^2);
    h = p .* cos(B) + (z + e2 * N .* sinB) .* sinB - N;