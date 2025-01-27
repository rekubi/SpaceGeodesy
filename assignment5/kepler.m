function [E_an] = kepler(M, e, tol, initial_guess)
    E = initial_guess;  
    iter = 0;          
    
    while true
        E_next = M + e * sin(E); 
        
        % Convergence?
        if abs(E_next - E) < tol
            break;
        end
        E = E_next;
    end 
    E_an = E;  % Eccentric anomaly
end