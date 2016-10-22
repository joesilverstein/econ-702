function [soln] = value3(gridk, nk, maxit, tol, alpha, beta, A)

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
                vhelp=-10^10; % initialization of vhelp (value is arbitrary)
                cons=A*gridk(kc)^alpha-gridk(kcc);
                if cons<=0.0; % prevents MATLAB from taking log of neg num
                    vhelp=-10^12;
                else
                    vhelp=log(cons)+beta*vfun(it-1,kcc);
                end;
                if vhelp>=vfun(it,kc)
                    vfun(it,kc)=vhelp;
                    gfun(it,kc)=gridk(kcc);
                end;
            end;
        end;
        diff=max(abs(vfun(it,:)-vfun(it-1,:))); % needs to access previous row here
    end;

    g = gfun(it,:)';
    v = vfun(it,:)';
    soln = [gridk v g];
    
    disp(it)
    
end

