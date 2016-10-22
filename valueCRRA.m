function [soln, capital] = valueCRRA(gridk, nk, maxit, tol, alpha, beta, A, sigma, k0)

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
            for kcc=1:nk;
                vfun(it,kc) = ((A*gridk(kc)^alpha-gridk(kcc))^(1-sigma)-1)/(1-sigma)+beta*vfun(it-1,kcc);
            end;
        end;
        diff=max(abs(vfun(it,:)-vfun(it-1,:)));
    end;

    %% Create Table of the value function for all k and k'
    table = zeros(nk);
    for kc=1:nk
        for kcc=1:nk
            table(kc,kcc) = ((A*gridk(kc)^alpha-gridk(kcc))^(1-sigma)-1)/(1-sigma)+beta*vfun(it,kcc);
        end;
    end;

    %% Report value and policy functions

    soln = zeros(nk,3);
    for kc=1:nk
        [maxval, maxind] = max(table(kc,:));
        gk = gridk(maxind);
        soln(kc,:) = [gridk(kc) maxval gk];
    end;
    
    disp(it)
    
    % Create table of first 100 elements of optimal capital and consumption
    % levels, using the policy rule computed above.
    capital = zeros(101,2);
    capital(1,2) = k0;
    k = k0;
    for t=1:100;
        % find index of k in first column of table
        ind = find(soln(:,1)==k);
        
        % set k equal to the output of the transition function (column 3 of
        % the solution table):
        k = soln(ind,3);
        
        capital(t+1,2) = k; % capital k_t+1
        capital(t,1) = A*capital(t,2)^alpha - k; % consumption c_t
    end;
    capital(101,1) = capital(100,1); % fill in last entry
    
end

