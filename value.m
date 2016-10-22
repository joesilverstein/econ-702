function [soln] = value(gridk, nk, maxit, tol, alpha, beta, A)

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
            vfun(it,kc)=-10^10;
            for kcc=1:nk;
                vhelp=-10^10;
                cons=A*gridk(kc)^alpha-gridk(kcc);
                if cons<=0.0;
                    vhelp=-10^12;
                else
                    vhelp=log(cons)+beta*vfun(it-1,kcc);
                end;
                if vhelp>=vfun(it,kc)
                    vfun(it,kc)=vhelp;
                end;
            end;
        end;
        diff=max(abs(vfun(it,:)-vfun(it-1,:)));
    end;

    %% Create Table of the value function for all k and k'
    table = zeros(nk);
    for kc=1:nk
        for kcc=1:nk
            table(kc,kcc)=log(A*gridk(kc)^alpha-gridk(kcc))+beta*vfun(it,kcc);
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
    
end

