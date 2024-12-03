function [E_an, i_ter] = kepler(M, e, tol, max_iter, initial_guess)
    E = initial_guess;  
    iter = 0;          
    
    while iter < max_iter
        iter = iter + 1;
        E_next = M + e * sin(E); 
        
        % Convergence?
        if abs(E_next - E) < tol
            break;
        end
        E = E_next;
    end
    if iter == max_iter
        % warning('Maximum iterations reached without convergence.');
    end

    E_an = E;  % Eccentric anomaly
    i_ter = iter;  % Number of iterations
end
