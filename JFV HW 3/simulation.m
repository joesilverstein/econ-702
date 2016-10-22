function [soln] = simulation(nagents,nperiods,gridb,maxb,nb,soln_val,turb)

w = [0.2 0.4 0.6 0.8 1];

% There are 6 states: 0=unemployed, 1=employed at w1,...,5=employed at wage
% w5.

% initialize all of the agents to unemployed (state 0)
state = zeros(nagents,1);

% start all agents with 1 unit of the bond:
% multiply by this value so it begins in the grid
savings = ones(nagents,1)*1.002004008016032; 

dpol1 = [gridb',soln_val(:,8)];
bpol1 = [gridb',soln_val(:,2)];

dpol2 = [gridb',soln_val(:,9)];
bpol2 = [gridb',soln_val(:,3)];

dpol3 = [gridb',soln_val(:,10)];
bpol3 = [gridb',soln_val(:,4)];

dpol4 = [gridb',soln_val(:,11)];
bpol4 = [gridb',soln_val(:,5)];

dpol5 = [gridb',soln_val(:,12)];
bpol5 = [gridb',soln_val(:,6)];

epol6 = [gridb',soln_val(:,13)];
bpol6 = [gridb',soln_val(:,7)];

v1 = [gridb',soln_val(:,14)];
v2 = [gridb',soln_val(:,15)];
v3 = [gridb',soln_val(:,16)];
v4 = [gridb',soln_val(:,17)];
v5 = [gridb',soln_val(:,18)];
v6 = [gridb',soln_val(:,19)];
vfuns = cell(6,1);
vfuns{1} = v1;
vfuns{2} = v2;
vfuns{3} = v3;
vfuns{4} = v4;
vfuns{5} = v5;
vfuns{6} = v6;

ind = 51; % initialization: closest index to 1
for t=1:nperiods
    for i=1:nagents
        if state(i)==0 %unemployed
            % Find index of closest value. It always exists.
            [minVal ind] = min(abs(gridb-savings(i)));
            
            % choose effort based on savings today
            e = epol6(ind,2); 
            savings(i) = bpol6(ind,2);
            
            offer = rand();
            if offer<=e^0.5 % she gets a wage offer
                wage = rand();
                % Check whether she is willing to accept the wage, in which
                % case she will become employed at that wage.
                % She accepts the offer if her value function of being
                % employed at that wage is higher than her value function
                % of remaining unemployed.
                for j=1:5
                    % Since wages are equally spaced between 0 and 1, we 
                    % can simulate in this way:
                    if wage<=w(j)
                        if vfuns{j}(ind,2)>=v6(ind,2)
                            state(i)=j;
                        end
                        % need to break out of loop because otherwise every
                        % wage offer is the highest
                        break;  
                    end
                end
            end
            % otherwise she remains unemployed, and we don't need to
            % change states
            
        else %employed
            if state(i)==1 % employed at wage w1
                d = dpol1(ind,2);
                savings(i) = bpol1(ind,2);
            elseif state(i)==2 % employed at wage w2
                d = dpol2(ind,2);
                savings(i) = bpol2(ind,2);
            elseif state(i)==3
                d = dpol3(ind,2);
                savings(i) = bpol3(ind,2);
            elseif state(i)==4
                d = dpol4(ind,2);
                savings(i) = bpol4(ind,2);
            else % employed at wage w5
                d = dpol5(ind,2);
                savings(i) = bpol5(ind,2);
            end
            
            loseJob = rand();
            if loseJob>=turb*d^0.5 % if she loses her job, she become unemployed
                state(i) = 0;
            end
        end
    end
end

soln = [savings state];

end

