function M_i = mir3d(axis)
    % Function to compute a 3D reflection matrix for a given mirror axis
    % Inputs:
    %   axis - the axis of reflection (1 for x, 2 for y, 3 for z)
    % Output:
    %   M_i - 3x3 reflection matrix

    % Define the reflection matrix based on the mirror axis
    if axis == 1  % Reflection about the x-axis
        M_i = [-1, 0, 0;
               0, 1, 0;
               0, 0, 1];
    elseif axis == 2  % Reflection about the y-axis
        M_i = [1, 0, 0;
               0, -1, 0;
               0, 0, 1];
    elseif axis == 3  % Reflection about the z-axis
        M_i = [1, 0, 0;
               0, 1, 0;
               0, 0, -1];
    else
        error('Axis must be 1, 2, or 3');
    end
end
