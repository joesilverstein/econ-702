function [soln] = capital(k0, alpha, beta, A)
    soln = zeros(101,2);
    soln(1,2) = k0;
    k = k0;
    for t=1:100;
        k = alpha*beta*A*k^alpha;
        soln(t+1,2) = k;

        soln(t,1) = A*soln(t,2)^alpha - k; % consumption c_t
    end;
    soln(101,1) = soln(100,1); % fill in last entry
end

