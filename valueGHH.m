function [soln, capital] = valueGHH(gridk, nk, maxit, tol, alpha, beta, A, k0)

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
            for kcc=1:nk;
                %vhelp=-10^10; % initialization of vhelp (value is arbitrary)
                inside = (A*gridk(kc)^alpha*n^(1-alpha)-gridk(kcc)-n);
                %{
                if inside==0
                    vhelp=-10^12;
                else
                %}
                    % value of transitioning to gridk(kcc):
                    vfun(it,kc) = log(inside)+beta*vfun(it-1,kcc); 
                    %{
                end;
                if vhelp>=vfun(it,kc)
                    vfun(it,kc)=vhelp; 
                end; 
                    %}
            end;
        end;
        diff=max(abs(vfun(it,:)-vfun(it-1,:)));
    end;

    %% Create Table of the value function for all k and k'
    table = zeros(nk);
    for kc=1:nk
        for kcc=1:nk
            table(kc,kcc) = log((A*gridk(kc)^alpha*n^(1-alpha)-gridk(kcc)-n))+beta*vfun(it,kcc);
        end;
    end;
    
    disp(table)

    %% Report value and policy functions

    soln = zeros(nk,3);
    for kc=1:nk
        [maxval, maxind] = max(table(kc,:));
        gk = gridk(maxind);
        soln(kc,:) = [gridk(kc) maxval gk];
    end;
    
    disp(it)
    
    capital = 0;
    %{
    % Create table of first 100 elements of optimal capital and consumption
    % levels, using the policy rule computed above.
    capital = zeros(51,3); % {ct,nt,kt+1}
    capital(1,2) = k0;
    k = k0;
    for t=1:50;
        % find index of k in first column of table
        ind = find(soln(:,1)==k);
        
        % set k equal to the output of the transition function (column 3 of
        % the solution table):
        k = soln(ind,3);
        
        capital(t+1,2) = k; % capital k_t+1
        capital(t,1) = A*capital(t,2)^alpha - k; % consumption c_t
    end;
    capital(51,1) = capital(50,1); % fill in last entry
    %}
end

