function W = polar_motion_matrix(year, month, day, hour, minute)
    % polar_motion_matrix: Compute the polar motion rotation matrix W.
    % Inputs:
    % - year, month, day: Date inputs.
    % - hour, minute: Time inputs.
    % Output:
    % - W: Polar motion matrix (3x3).

    % Validate inputs
    if ~is_valid_date(year, month, day, hour, minute)
        error('Invalid date');
    end
    
    % Convert target date and time to datetime
    targetDateTime = datetime(year, month, day, hour, minute, 0);
    
    % Read polar motion data from file
    dataFile = 'polar_motion.txt'; % Update with the actual file name
    if ~isfile(dataFile)
        error('Polar motion data file not found. Please provide "%s".', dataFile);
    end
    
    % Load polar motion data
    % File columns: year, month, day, xp (arcseconds), yp (arcseconds)
    data=readtable("polar_motion.txt", NumHeaderLines=1);
    
    % Combine columns to create datetime array
    dates = datetime(data.Var1, data.Var2, data.Var3);
    
    % Convert xp and yp to radians
    xp = data.Var4 * (pi / 648000); % Convert arcseconds to radians
    yp = data.Var5 * (pi / 648000); % Convert arcseconds to radians
    
    % Interpolate xp and yp to match targetDateTime
    xp_interp = interp1(dates, xp, targetDateTime);
    yp_interp = interp1(dates, yp, targetDateTime);
    
    % Compute the rotation matrices
    R1 = [1, 0, 0; 0, cos(-yp_interp), sin(-yp_interp); 0, -sin(-yp_interp), cos(-yp_interp)]; % around x-axis
    R2 = [cos(-xp_interp), 0, -sin(-xp_interp); 0, 1, 0; sin(-xp_interp), 0, cos(-xp_interp)]; % around y-axis
    
    % Compute the polar motion matrix
    W = R2 * R1;
    
end

function is_valid = is_valid_date(y, month, d, h, m)
    % Check if the inputs are valid  
    % Check that they are scalars
    is_valid=true;
    if ~(isscalar(y) && isscalar(month) && isscalar(d) && isscalar(h) && isscalar(m))
        is_valid = false;
    % Check that inputs are in the valid range
    elseif y==2024 && month==12 && d==31 && any([h, m] > 0)
        is_valid = false;
    elseif ~all([y, month, d] > 0) || ~all([h, m] >= 0) || y~=2024 || m>59 || h>23 || (month > 12) || (d > 31)
        is_valid = false;
    elseif any(rem([y, month, d, h, m], 1))
        is_valid = false;
    % The inputs could be a valid date, let's see if they actually are
    else
     % Vector of the number of days for each month
        daysInMonth = [31 29 31 30 31 30 31 31 30 31 30 31];

        maxDay = daysInMonth(month);
        if d > maxDay
            is_valid = false;
        else
            is_valid = true;
        end
    end
end