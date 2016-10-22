function [soln] = simulation_s(nagents,nperiods,gridb,maxb,nb,soln_val,turb)

w = [0.2 0.4 0.6 0.8 1];

% There are 6 states: 0=unemployed, 1=employed at w1,...,5=employed at wage
% w5.

% initialize all of the agents to unemployed (state 0)
state = zeros(nagents,1);

% start all agents with 1 unit of the bond:
savings = ones(nagents,1);

% The agent chooses b' and d before deciding whether to search-on-the job,
% so there is only one set of policy functions.
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

dpol = cell(6,1);
bpol = cell(6,1);
dpol{1}=dpol1; dpol{2}=dpol2; dpol{3}=dpol3; dpol{4}=dpol4; dpol{5}=dpol5; dpol{6}=epol6;
bpol{1}=bpol1; bpol{2}=bpol2; bpol{3}=bpol3; bpol{4}=bpol4; bpol{5}=bpol5; bpol{6}=bpol6;

v1 = [gridb',soln_val(:,14)];
v2 = [gridb',soln_val(:,15)];
v3 = [gridb',soln_val(:,16)];
v4 = [gridb',soln_val(:,17)];
v5 = [gridb',soln_val(:,18)];
v6 = [gridb',soln_val(:,19)];
v1_s = [gridb',soln_val(:,20)];
v2_s = [gridb',soln_val(:,21)];
v3_s = [gridb',soln_val(:,22)];
v4_s = [gridb',soln_val(:,23)];
v5_s = [gridb',soln_val(:,24)];
vfuns = cell(6,1);
vfuns{1} = v1;
vfuns{2} = v2;
vfuns{3} = v3;
vfuns{4} = v4;
vfuns{5} = v5;
vfuns{6} = v6;
vfuns_s = cell(5,1); % holds the value functions of searching
vfuns_s{1} = v1_s;
vfuns_s{2} = v2_s;
vfuns_s{3} = v3_s;
vfuns_s{4} = v4_s;
vfuns_s{5} = v5_s;

for t=1:nperiods
    for i=1:nagents
        if state(i)==0 %unemployed
            
            % choose effort based on savings today
            e = epol6(floor((savings(i)/maxb)*nb)+1,2); 
            savings(i) = bpol6(floor((savings(i)/maxb)*nb)+1,2);
            
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
                        if vfuns{j}(floor((savings(i)/maxb)*nb)+1,2)>=v6(floor((savings(i)/maxb)*nb)+1,2)
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
            % choose b' and d before deciding whether to search
            d = dpol{state(i)}(floor((savings(i)/maxb)*nb)+1,2);
            savings(i) = bpol{state(i)}(floor((savings(i)/maxb)*nb)+1,2);
            
            % Choose whether or not to search:
            accept = 0;
            if vfuns_s{state(i)}(floor((savings(i)/maxb)*nb)+1,2)>=vfuns{state(i)}(floor((savings(i)/maxb)*nb)+1,2)
                % gets wage offer for sure
                newState=unidrnd(5); % draw a state from 1 to 5 with equal weight on each
                
                % if he is offered a higher wage than he currently has (corresponding to a higher state), he
                % will accept it
                if newState>state(i) 
                    state(i) = newState;
                    accept = 1;
                end
            end
            
            if accept==0
                loseJob = rand();
                if loseJob>=turb*d^0.5 % if she loses her job, she become unemployed
                    state(i) = 0;
                end
            end
        end
    end
end

soln = [savings state];

end

