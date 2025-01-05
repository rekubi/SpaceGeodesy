
function [x,y,z]=ellipsoid_to_cartesian(B,L,h, model)
    % Robustness
    if ~isscalar(B)
        error('B is not a scalar')
    end
    if ~isscalar(L)
        error('L is not a scalar')
    end
    if ~isscalar(h)
        error('h is not a scalar')
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

    e2 = 2 * f - f ^ 2;
    N = a ./ sqrt(1 - e2 * sin(B).^2);
    x = (N + h) * cos(B) * cos(L);
    y = (N + h) * cos(B) * sin(L);
    z = (N - e2 * N + h) * sin(B);