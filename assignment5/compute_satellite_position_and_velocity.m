function [pos_ECI, vel_ECI]  = compute_satellite_position_and_velocity(a, T, e_sat, i_sat_deg, RAAN_sat_deg_deg, omega_sat_deg, M_sat_epoch_deg)
    % satellite_ECI_trajectory_given_a_T
    % Computes the position and velocity vectors of a satellite in ECI coordinates
    % over a specified time duration using known semi-major axis and orbital period.
    %
    % Inputs:
    %   a           - Semi-major axis [meters]
    %   T           - Orbital period [minutes]
    %   n_sat       - Mean motion [rev/day]
    %   e_sat       - Eccentricity
    %   i_sat_deg   - Inclination [degrees]
    %   RAAN_sat_deg    - Right Ascension of Ascending Node [degrees]
    %   omega_sat_deg   - Argument of Perigee [degrees]
    %   M_sat_epoch_deg - Mean Anomaly at epoch [degrees]
    %   t_epoch     - t epoch in [UT1]

    %
    % Outputs:
    %   pos_ECI     - Position vectors in ECI coordinates [km]
    %   vel_ECI     - Velocity vectors in ECI coordinates [km/s]

    % Constants
    minutes_in_day = 1440; % Number of minutes in a day
    GM = 398600.44; % Earth's gravitational parameter [km^3/s^2]

    % Convert angles from degrees to radians
    i = i_sat_deg * (pi / 180);
    RAAN = RAAN_sat_deg * (pi / 180);
    omega = omega_sat_deg * (pi / 180);
    M_sat_epoch = M_sat_epoch_deg * (pi / 180);

    % Compute the transformation matrix R
    R_orb_to_ECI = [
        cos(RAAN) * cos(omega) - sin(RAAN) * sin(omega) * cos(i), ...
        -cos(RAAN) * sin(omega) - sin(RAAN) * cos(omega) * cos(i), ...
        sin(RAAN) * sin(i);
        sin(RAAN) * cos(omega) + cos(RAAN) * sin(omega) * cos(i), ...
        -sin(RAAN) * sin(omega) + cos(RAAN) * cos(omega) * cos(i), ...
        -cos(RAAN) * sin(i);
        sin(omega) * sin(i), ...
        cos(omega) * sin(i), ...
        cos(i)
    ];
    % Unit vector normal to the orbital plane (C)
    C = [sin(RAAN) * sin(i); -cos(RAAN) * sin(i); cos(i)];
    % Unit vector normal of the line of nodes (K)
    K = [cos(RAAN); sin(RAAN); 0];
    % Compute the P vector
    P = cos(omega) * K + sin(omega) * cross(C,K);
    % Compute the Q vector
    Q = -sin(omega) * K + cos(omega) * cross(C,K);


    pos_ECI = zeros(minutes_in_day, 3);
    vel_ECI = zeros(minutes_in_day, 3);

    % Parameters for Kepler's equation solver
    tol = 1e-9; % Tolerance for convergence
    initial_guess = M_sat_epoch; % Initial guess for the first step

    % Time integration loop
    for i = 1:num_steps
        t_i = (i - 1) * time_step; % Current time [min]
        t_i_days = t_i / minutes_in_day; % Time in days

        % Mean anomaly at time t_i
        M_i = t_i * n_sat * 2 * pi; % Incremental mean anomaly in radians
        M_sat_i = M_sat_epoch + M_i; % Total mean anomaly at time t_i

        % Solve Kepler's equation using the provided function
        E = kepler(M_sat_i, e_sat, tol, initial_guess);

        % True anomaly from eccentric anomaly
        v_sat_i = atan2(sqrt(1 - e_sat^2) * sin(E), cos(E) - e_sat);

        % Distance to the geocenter
        r_sat_i = a * (1 - e_sat*cos(E));

        % Position vector in the orbital frame
        r_orbital = [r_sat_i * cos(v_sat_i); r_sat_i * sin(v_sat_i); 0];
        
        % Transform the position vector from orbital frame to ECI
        pos_ECI(i, :) = (R_orb_to_ECI * r_orbital)';

        % Calculate the parameter p
        p = norm(r_orbital) * (1 + e_sat * cos(v_sat_i));
        C = sqrt(p*GM);

        vel_ECI(i, :) = c/p * (-sin(v_sat_i) * P + (e + cos(v_sat_i)) * Q)';

        % Update the initial guess for the next time step
        initial_guess = E;
    end

end