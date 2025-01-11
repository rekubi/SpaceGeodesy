function R_i = rot3d(angle, axis)
    % Function to compute a 3D rotation matrix for a given angle and axis
    % Inputs:
    %   angle - the rotation angle in radians
    %   axis - the axis of rotation (1 for x, 2 for y, 3 for z)
    % Output:
    %   R_i - 3x3 rotation matrix
    
    % Ensure angle is a scalar and axis is valid
    if nargin < 2
        error('Not enough input arguments. Provide both angle and axis.');
    end

    % Validate that the angle is a scalar
    if ~isscalar(angle)
        error('Angle must be a scalar.');
    end
    
    if axis == 1  % Rotation about the x-axis (e1)
        R_i = [1, 0, 0; 
               0, cos(angle), -sin(angle);
               0, sin(angle), cos(angle)];
    elseif axis == 2  % Rotation about the y-axis (e2)
        R_i = [cos(angle), 0, -sin(angle); 
               0, 1, 0; 
               sin(angle), 0, cos(angle)];
    elseif axis == 3  % Rotation about the z-axis (e3)
        R_i = [cos(angle), sin(angle), 0; 
               -sin(angle), cos(angle), 0; 
               0, 0, 1];
    else
        error('Axis must be 1, 2, or 3');
    end
end