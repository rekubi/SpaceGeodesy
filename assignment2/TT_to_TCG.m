function [d_TCG] = TT_to_TCG(d_TT)
% A function that takes in time difference in TT and converts it into time
% different in TCG, note that the intended use here is mainly for small time delays
% Args: d_TT: time diff in TT seconds
% Output: d_TCG: time diff in TCG seconds

% Constants
Lg = 6.969290134e-10;
% Output equation
d_TCG = (1 + (Lg / (1 - Lg))) * d_TT;
end