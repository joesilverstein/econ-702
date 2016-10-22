function [soln] = value_JFV_hw3(gridb, gridd, nb, nd, maxit, tol, z, turb, ojs)

    w = [0.2 0.4 0.6 0.8 1];

    % Initial Value Function:
    % vfun is a 3-D array whose first argument is the iteration, 2nd
    % argument is the grid index of b, and 3rd arg is the grid index of d/e.
    vfun1(1,1:nb)=0; % value function of worker employed at wage w1
    vfun2(1,1:nb)=0;
    vfun3(1,1:nb)=0;
    vfun4(1,1:nb)=0;
    vfun5(1,1:nb)=0;
    vfun6(1,1:nb)=0; % unemployed worker's value function
    
    % value of choosing on-the-job search at each wage:
    vfun1_s(1,1:nb)=-10^10;
    vfun2_s(1,1:nb)=-10^10;
    vfun3_s(1,1:nb)=-10^10;
    vfun4_s(1,1:nb)=-10^10;
    vfun5_s(1,1:nb)=-10^10;

    %% Value function iteration

    it=1;
    
    diff1=10^10;
    diff2=10^10;
    diff3=10^10;
    diff4=10^10;
    diff5=10^10;
    diff6=10^10;
    diff = [diff1 diff2 diff3 diff4 diff5 diff6];
    maxDiff = max(diff);

    while it<=maxit && maxDiff>tol;
        
        it=it+1;
        
        for bc=1:nb
            
            % usual value functions
            vfun1(it,bc)=-10^10;
            vfun2(it,bc)=-10^10;
            vfun3(it,bc)=-10^10;
            vfun4(it,bc)=-10^10;
            vfun5(it,bc)=-10^10;
            vfun6(it,bc)=-10^10;
            
            % value of choosing on-the-job search at each wage:
            vfun1_s(it,bc)=-10^10;
            vfun2_s(it,bc)=-10^10;
            vfun3_s(it,bc)=-10^10;
            vfun4_s(it,bc)=-10^10;
            vfun5_s(it,bc)=-10^10;
            
            for dc=1:nd
            
                for bcc=1:nb

                    c1=1.03*gridb(bc)+w(1)-gridb(bcc); % consumption at wage w1
                    c2=1.03*gridb(bc)+w(2)-gridb(bcc);
                    c3=1.03*gridb(bc)+w(3)-gridb(bcc);
                    c4=1.03*gridb(bc)+w(4)-gridb(bcc);
                    c5=1.03*gridb(bc)+w(5)-gridb(bcc);
                    c6=1.03*gridb(bc)+z-gridb(bcc);

                    %% Value function of agent employed at wage w1:

                    arg1 = c1-0.8*gridd(dc)^1.5;
                    if arg1<=0.0; % prevents MATLAB from taking log of neg num
                        vhelp1=-10^12;
                    else
                        % Approximate next value function:
                        vhelp1=log(arg1)+0.95*(turb*gridd(dc)^0.5*vfun1(it-1,bcc)+(1-turb*gridd(dc)^0.5)*vfun6(it-1,bcc));
                    end;
                    
                    if ojs==1 % if on-the-job search is an option
                        arg1_s = c1-0.8*gridd(dc)^1.5-0.25; % same as before
                        if arg1_s<=0.0
                            vhelp1_s = -10^12;
                        else
                            max1 = max(vfun1(it-1,bcc), gridd(dc)^0.5*vfun1(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max2 = max(vfun2(it-1,bcc), gridd(dc)^0.5*vfun2(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max3 = max(vfun3(it-1,bcc), gridd(dc)^0.5*vfun3(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max4 = max(vfun4(it-1,bcc), gridd(dc)^0.5*vfun4(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max5 = max(vfun5(it-1,bcc), gridd(dc)^0.5*vfun5(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            vhelp1_s = log(arg1_s)+0.95*(0.2*(max1+max2+max3+max4+max5));
                        end;
                        
                        % Need to keep track of OJS value functions for the
                        % simulation
                        if vhelp1_s>=vfun1_s(it,bc)
                            vfun1_s(it,bc) = vhelp1_s;
                        end
                        
                        vhelp1 = max(vhelp1,vhelp1_s); % if OJS is a better option, she chooses it
                    end;

                    if vhelp1>=vfun1(it,bc)
                        % for each iteration of the d loop, vfun1 updates to a higher value if necessary
                        vfun1(it,bc)=vhelp1; 
                        bfun1(it,bc)=gridb(bcc);
                        dfun1(it,bc)=gridd(dc);
                    end;

                    %% Value function of agent employed at wage w2:

                    arg2 = c2-0.8*gridd(dc)^1.5;
                    if arg2<=0.0; % prevents MATLAB from taking log of neg num
                        vhelp2=-10^12;
                    else
                        % Approximate next value function:
                        vhelp2=log(arg2)+0.95*(turb*gridd(dc)^0.5*vfun2(it-1,bcc)+(1-turb*gridd(dc)^0.5)*vfun6(it-1,bcc));
                    end;
                    
                    if ojs==1 % if on-the-job search is an option
                        arg2_s = c2-0.8*gridd(dc)^1.5-0.25; % same as before
                        if arg2_s<=0.0
                            vhelp2_s = -10^12;
                        else
                            max1 = max(vfun1(it-1,bcc), gridd(dc)^0.5*vfun1(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max2 = max(vfun2(it-1,bcc), gridd(dc)^0.5*vfun2(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max3 = max(vfun3(it-1,bcc), gridd(dc)^0.5*vfun3(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max4 = max(vfun4(it-1,bcc), gridd(dc)^0.5*vfun4(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max5 = max(vfun5(it-1,bcc), gridd(dc)^0.5*vfun5(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            vhelp2_s = log(arg2_s)+0.95*(0.2*(max1+max2+max3+max4+max5));
                        end;
                        
                        if vhelp2_s>=vfun2_s(it,bc)
                            vfun2_s(it,bc) = vhelp2_s;
                        end
                        
                        vhelp2 = max(vhelp2,vhelp2_s); % if OJS is a better option, she chooses it
                    end;

                    if vhelp2>=vfun2(it,bc)
                        vfun2(it,bc)=vhelp2;
                        bfun2(it,bc)=gridb(bcc);
                        dfun2(it,bc)=gridd(dc);
                    end;

                    %% Value function of agent employed at wage w3:

                    arg3 = c3-0.8*gridd(dc)^1.5;
                    if arg3<=0.0; % prevents MATLAB from taking log of neg num
                        vhelp3=-10^12;
                    else
                        % Approximate next value function:
                        vhelp3=log(arg3)+0.95*(turb*gridd(dc)^0.5*vfun3(it-1,bcc)+(1-turb*gridd(dc)^0.5)*vfun6(it-1,bcc));
                    end;
                    
                    if ojs==1 % if on-the-job search is an option
                        arg3_s = c3-0.8*gridd(dc)^1.5-0.25; % same as before
                        if arg3_s<=0.0
                            vhelp3_s = -10^12;
                        else
                            max1 = max(vfun1(it-1,bcc), gridd(dc)^0.5*vfun1(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max2 = max(vfun2(it-1,bcc), gridd(dc)^0.5*vfun2(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max3 = max(vfun3(it-1,bcc), gridd(dc)^0.5*vfun3(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max4 = max(vfun4(it-1,bcc), gridd(dc)^0.5*vfun4(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max5 = max(vfun5(it-1,bcc), gridd(dc)^0.5*vfun5(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            vhelp3_s = log(arg3_s)+0.95*(0.2*(max1+max2+max3+max4+max5));
                        end;
                        
                        if vhelp3_s>=vfun3_s(it,bc)
                            vfun3_s(it,bc) = vhelp3_s;
                        end
                        
                        vhelp3 = max(vhelp3,vhelp3_s); % if OJS is a better option, she chooses it
                    end;

                    if vhelp3>=vfun3(it,bc)
                        vfun3(it,bc)=vhelp3;
                        bfun3(it,bc)=gridb(bcc);
                        dfun3(it,bc)=gridd(dc);
                    end;

                    %% Value function of agent employed at wage w4:

                    arg4 = c4-0.8*gridd(dc)^1.5;
                    if arg4<=0.0; % prevents MATLAB from taking log of neg num
                        vhelp4=-10^12;
                    else
                        % Approximate next value function:
                        vhelp4=log(arg4)+0.95*(turb*gridd(dc)^0.5*vfun4(it-1,bcc)+(1-turb*gridd(dc)^0.5)*vfun6(it-1,bcc));
                    end;
                    
                    if ojs==1 % if on-the-job search is an option
                        arg4_s = c4-0.8*gridd(dc)^1.5-0.25; % same as before
                        if arg4_s<=0.0
                            vhelp4_s = -10^12;
                        else
                            max1 = max(vfun1(it-1,bcc), gridd(dc)^0.5*vfun1(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max2 = max(vfun2(it-1,bcc), gridd(dc)^0.5*vfun2(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max3 = max(vfun3(it-1,bcc), gridd(dc)^0.5*vfun3(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max4 = max(vfun4(it-1,bcc), gridd(dc)^0.5*vfun4(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max5 = max(vfun5(it-1,bcc), gridd(dc)^0.5*vfun5(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            vhelp4_s = log(arg4_s)+0.95*(0.2*(max1+max2+max3+max4+max5));
                        end;
                        
                        if vhelp4_s>=vfun4_s(it,bc)
                            vfun4_s(it,bc) = vhelp4_s;
                        end
                        
                        vhelp4 = max(vhelp4,vhelp4_s); % if OJS is a better option, she chooses it
                    end;

                    if vhelp4>=vfun4(it,bc)
                        vfun4(it,bc)=vhelp4;
                        bfun4(it,bc)=gridb(bcc);
                        dfun4(it,bc)=gridd(dc);
                    end;

                    %% Value function of agent employed at wage w5:

                    arg5 = c5-0.8*gridd(dc)^1.5;
                    if arg5<=0.0; % prevents MATLAB from taking log of neg num
                        vhelp5=-10^12;
                    else
                        % Approximate next value function:
                        vhelp5=log(arg5)+0.95*(turb*gridd(dc)^0.5*vfun5(it-1,bcc)+(1-turb*gridd(dc)^0.5)*vfun6(it-1,bcc));
                    end;
                    
                    if ojs==1 % if on-the-job search is an option
                        arg5_s = c5-0.8*gridd(dc)^1.5-0.25; % same as before
                        if arg5_s<=0.0
                            vhelp5_s = -10^12;
                        else
                            max1 = max(vfun1(it-1,bcc), gridd(dc)^0.5*vfun1(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max2 = max(vfun2(it-1,bcc), gridd(dc)^0.5*vfun2(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max3 = max(vfun3(it-1,bcc), gridd(dc)^0.5*vfun3(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max4 = max(vfun4(it-1,bcc), gridd(dc)^0.5*vfun4(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            max5 = max(vfun5(it-1,bcc), gridd(dc)^0.5*vfun5(it-1,bcc)+(1-gridd(dc)^0.5)*vfun6(it-1,bcc));
                            vhelp5_s = log(arg5_s)+0.95*(0.2*(max1+max2+max3+max4+max5));
                        end;
                        
                        if vhelp5_s>=vfun5_s(it,bc)
                            vfun5_s(it,bc) = vhelp5_s;
                        end
                        
                        vhelp5 = max(vhelp5,vhelp5_s); % if OJS is a better option, she chooses it
                    end;

                    if vhelp5>=vfun5(it,bc)
                        vfun5(it,bc)=vhelp5;
                        bfun5(it,bc)=gridb(bcc);
                        dfun5(it,bc)=gridd(dc);
                    end;

                    %% Value function of unemployed agent:

                    arg6 = c6-0.8*gridd(dc)^1.5;
                    if arg6<=0.0; % prevents MATLAB from taking log of neg num
                        vhelp6=-10^12;
                    else
                        % Approximate next value function:
                        max1 = max(vfun1(it-1,bcc),vfun6(it-1,bcc));
                        max2 = max(vfun2(it-1,bcc),vfun6(it-1,bcc));
                        max3 = max(vfun3(it-1,bcc),vfun6(it-1,bcc));
                        max4 = max(vfun4(it-1,bcc),vfun6(it-1,bcc));
                        max5 = max(vfun5(it-1,bcc),vfun6(it-1,bcc));
                        vhelp6=log(arg6)+0.95*(turb*gridd(dc)^0.5*0.2*(max1+max2+max3+max4+max5)+(1-turb*gridd(dc)^0.5)*vfun6(it-1,bcc));
                    end;

                    if vhelp6>=vfun6(it,bc)
                        vfun6(it,bc)=vhelp6;
                        bfun6(it,bc)=gridb(bcc);
                        efun(it,bc)=gridd(dc);
                    end;

                end;
            
            end;
            
        end;
        
        diff1 = max(abs(vfun1(it,:)-vfun1(it-1,:))); % needs to access previous row here
        diff2 = max(abs(vfun2(it,:)-vfun2(it-1,:)));
        diff3 = max(abs(vfun3(it,:)-vfun3(it-1,:)));
        diff4 = max(abs(vfun4(it,:)-vfun4(it-1,:)));
        diff5 = max(abs(vfun5(it,:)-vfun5(it-1,:)));
        diff6 = max(abs(vfun6(it,:)-vfun6(it-1,:)));
        diff = [diff1 diff2 diff3 diff4 diff5 diff6];
        
        maxDiff = max(diff);
        disp(maxDiff)
        disp(it)
        
    end;

    % Policy functions:
    b1 = bfun1(it,:)';
    b2 = bfun2(it,:)';
    b3 = bfun3(it,:)';
    b4 = bfun4(it,:)';
    b5 = bfun5(it,:)';
    b6 = bfun6(it,:)';
    d1 = dfun1(it,:)';
    d2 = dfun2(it,:)';
    d3 = dfun3(it,:)';
    d4 = dfun4(it,:)';
    d5 = dfun5(it,:)';
    e = efun(it,:)';
    
    v1 = vfun1(it,:)';
    v2 = vfun2(it,:)';
    v3 = vfun3(it,:)';
    v4 = vfun4(it,:)';
    v5 = vfun5(it,:)';
    v6 = vfun6(it,:)';
    
    if ojs==1
        v1_s = vfun1_s(it,:)';
        v2_s = vfun2_s(it,:)';
        v3_s = vfun3_s(it,:)';
        v4_s = vfun4_s(it,:)';
        v5_s = vfun5_s(it,:)';
        soln = [gridb' b1 b2 b3 b4 b5 b6 d1 d2 d3 d4 d5 e v1 v2 v3 v4 v5 v6 v1_s v2_s v3_s v4_s v5_s];
    else
        soln = [gridb' b1 b2 b3 b4 b5 b6 d1 d2 d3 d4 d5 e v1 v2 v3 v4 v5 v6];
    end
    
end

