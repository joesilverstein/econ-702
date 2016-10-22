function [soln, capital] = valueGHH2(gridk, nk, maxit, tol, alpha, beta, A, k0)

    %% Numerical Solution

    % Initial Value Function:
    % vfun is a matrix where each row is an iteration and each column is a
    % value of k.
    vfun(1,1:nk)=0.0;

    %% Value function iteration

    it=1;
    diff=10^10;

    while it<=maxit && diff>tol;
        it=it+1;
        for kc=1:nk;
            % compute optimal n (not a state variable)
            % note that n will never be negative, but will be 0 when k=0;
            n = ((1-alpha)*A)^(1/alpha)*gridk(kc); 
            % needs to be initialized to something small so that
            % 'vhelp>=vfun(it,kc)' will be satisfied later.
            vfun(it,kc) = -realmax; 
            gfun(it,kc) = 0;
            for kcc=1:nk;
                vhelp=-10^10; % initialization of vhelp (value is arbitrary)
                inside = (A*gridk(kc)^alpha*n^(1-alpha)-gridk(kcc)-n);
                % log(0)=-Inf. Instead, set to smallest possible value
                if inside<=0.0 
                    vhelp = -10^12;
                else
                    vhelp = log(inside)+beta*vfun(it-1,kcc); 
                end;
                if vhelp>vfun(it,kc) 
                    vfun(it,kc) = vhelp;
                    gfun(it,kc) = gridk(kcc);
                end;
            end;
        end;
        diff=max(abs(vfun(it,:)-vfun(it-1,:)));
    end;
    
    g = gfun(it,:)';
    v = vfun(it,:)';
    soln = [gridk' v g];
    
    disp(it)
    
    % Create table of first 100 elements of optimal capital and consumption
    % levels, using the policy rule computed above.
    capital = zeros(51,3);
    capital(1,3) = k0;
    k = k0;
    for t=1:50;
        % find index of k in first column of table
        ind = find(soln(:,1)==k);
        
        % set k equal to the output of the transition function (column 3 of
        % the solution table):
        k = soln(ind,3); % this step sets k = k'
        
        capital(t+1,3) = k; % capital k_t+1
        
        capital(t,2) = ((1-alpha)*A)^(1/alpha)*capital(t,3); % labor supply n_t
        capital(t,1) = A*capital(t,3)^alpha*n^(1-alpha) - k; % consumption c_t
    end;
    capital(51,1:2) = capital(50,1:2); % fill in last entry
    
end

