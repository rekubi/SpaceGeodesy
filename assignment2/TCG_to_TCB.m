function [d_TCB] = TCG_to_TCB(d_TCG)
% A function that takes in time difference in TCG and converts it into time
% different in TCB, note that the intended use here is mainly for small time delays
% Args: d_TCG: time diff in TCG seconds
% Output: d_TCB: time diff in TCB seconds

% Constants
c = 299792458;
bc_velocity = 30000;
AU = 149597870.7;

% Gravitational terms of individual celestial bodies
% Ordered by: Sun, Mercury, Venus, Moon, Mars, Ceres, Jupiter, Saturn,
% Uranus, Neptune, Pluto, Eris.
grav_terms = [1.32712440018e20, 2.2032e13, 3.24859e14, 4.9048695e12, 4.282837e13, ...
              6.26325e10, 1.26686534e17, 3.7931187e16, 5.793939e15, 6.836529e15, ...
              8.71e11, 1.108e12];
m_dist_to_earth = [AU, 91691000, 41400000, 385000.6, 78340000, 414000000, 628730000, ...
                   1275000000, 2723950000, 4351400000, 5890000000, 96.1*AU];
% Sum of external gravitational terms
V_ext = sum(grav_terms./m_dist_to_earth);
% Output equation
denominator = 1 - 1/c^2 *(bc_velocity^2/2 + V_ext);
d_TCB = d_TCG/denominator;
end