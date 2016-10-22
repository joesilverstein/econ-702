% This m-file solves the numerics of problem set 2, question 1
% Coded by Cezar Santos, Pilar Alcalde, and Devin Reilly, modified by
% Eugenio Rojas

clear all; 
clc; 
close all;

tic                                        % initializing the timer

% PARAMETERS 

A        = 20; 
aalpha   = 0.3; 
bbeta    = 0.85;
max_iter = 10000;
tol      = 1.0e-4;
n_grid   = 201;                            % numbers of elements in the grid

% PRELIMINARIES

% 0. Calculate the steady state capital level
k_ss = (A*aalpha*bbeta)^(1/(1-aalpha));

% 1. Set the grid for this period's capital.

kmin = k_ss*0.8;
kmax = k_ss*1.2;
k    = linspace(kmin,kmax,n_grid)';     

% 2. Compute this period's utility for each k, k'
%    This will be useful in the actual iteration (the flow utilities will
%    never change in the iteration even as the value function updates).

utility = zeros(n_grid, n_grid);
for ii = 1:n_grid       %Today's capital
    for jj = 1:n_grid   %Tomorrow's capital
        help = A * (k(ii)^aalpha) - k(jj);  %Calculate implied consumption
        if help > 0                         %If consumption positive, flow utility
            utility(ii,jj) = log(help);
        else                                %If cons <= 0, penalize with a large number
            utility(ii,jj) = -99999;
        end
    end
end

% 3. Value function iteration

iter = 0;                                   % Start iteration number at 0
diff = tol + 1;                             % To make sure loop actually starts
v0   = zeros(n_grid,1);                     % Initial guess for the value function

v1_store   = zeros(n_grid,3);
v_possible = zeros(n_grid, n_grid);

while diff > tol  &&  iter < max_iter
    iter = iter + 1;
    v_possible = utility + bbeta*ones(n_grid,1)*v0';
    [v1 ind] = max(v_possible,[],2);
    policy = k(ind);
    diff = max(abs(v1 - v0));
    v0 = v1;
    
    if iter <= 3
        v1_store(:,iter) = v1;
    end
end

% PLOTS

figure(1)
plot(k, v1_store(:,1), 'k', k, v1_store(:,2), '--k', k, v1_store(:,3), '-.k')
title('value function - iterations 1 through 3')
xlabel('k')
axis tight
legend('Iter 1','Iter 2','Iter 3',4)
%saveas(gcf,'q1_part4.eps')


% TRUE VALUE FUNCTION AND GRAPH
k_grid = linspace(kmin,kmax,n_grid);
a1 = aalpha/(1-aalpha*bbeta);
a0 = 1/(1-bbeta)*( bbeta*a1*log(aalpha*bbeta) + a1*log(A)/aalpha + log(1-aalpha*bbeta) );
value = a0 + a1*log(k_grid);

figure(2)
plot(k_grid, value, 'k', k, v1, 'k-.')
title('value function')
xlabel('k')
axis tight
legend('true','numerical solution',4)
saveas(gcf,'q1_part8_vfn.eps')

% TRUE POLICY FUNCTION AND GRAPH
truepolicy = A*aalpha*bbeta*(k_grid.^aalpha);

figure(3)
plot(k_grid, truepolicy, 'k', k, policy, 'k-.')
title('policy function')
xlabel('k')
axis tight
legend('true','numerical solution',4)
saveas(gcf,'q1_part8_polfn.eps')

% SIMULATION
kt = 0.9*k_ss;
kt1 = zeros(100,1);
ct  = zeros(100,1);
for ii = 1:length(kt1)
    kt1(ii) = A*aalpha*bbeta*(kt^aalpha);
    ct(ii)  = A*(kt^aalpha) - kt1(ii);
    kt     = kt1(ii);
end
figure(4)
plot(kt1)
hold on;
plot(ct,'--k')
title(['Simulation, \beta = ' num2str(bbeta)])
xlabel('t')
legend('Capital Stock','Consumption')
ylim([0 35])
saveas(gcf,'q1_part8_sim.eps')

toc      % stop the timer

%% Question 1.9 


clear all; 
clc; 
%close all;

tic                                        % initializing the timer

% PARAMETERS 

A        = 20; 
aalpha   = 0.3; 
bbeta    = 0.85;
ssigma   = 3;
max_iter = 10000;
tol      = 1.0e-4;
n_grid   = 201;                            % numbers of elements in the grid

% PRELIMINARIES

% 0. Calculate the steady state capital level
k_ss = (A*aalpha*bbeta)^(1/(1-aalpha));

% 1. Set the grid for this period's capital.

kmin = k_ss*0.8;
kmax = k_ss*1.2;
k    = linspace(kmin,kmax,n_grid)';     

% 2. Compute this period's utility for each k, k'
%    This will be useful in the actual iteration (the flow utilities will
%    never change in the iteration even as the value function updates).

utility = zeros(n_grid, n_grid);
for ii = 1:n_grid       %Today's capital
    for jj = 1:n_grid   %Tomorrow's capital
        help = A * (k(ii)^aalpha) - k(jj);  %Calculate implied consumption
        if help > 0                         %If consumption positive, flow utility
            utility(ii,jj) = ((help)^(1-ssigma))/(1-ssigma);
        else                                %If cons <= 0, penalize with a large number
            utility(ii,jj) = -99999;
        end
    end
end

% 3. Value function iteration

iter = 0;                                   % Start iteration number at 0
diff = tol + 1;                             % To make sure loop actually starts
v0   = zeros(n_grid,1);                     % Initial guess for the value function

v1_store   = zeros(n_grid,3);
v_possible = zeros(n_grid, n_grid);

while diff > tol  &&  iter < max_iter
    iter = iter + 1;
    v_possible = utility + bbeta*ones(n_grid,1)*v0';
    [v1 ind] = max(v_possible,[],2);
    policy = k(ind);
    diff = max(abs(v1 - v0));
    v0 = v1;
    
    if iter <= 3
        v1_store(:,iter) = v1;
    end
end

% Compute consumption policy function

cpol = zeros(length(policy),1);
for i = 1:length(policy)
    cpol(i,1) = A*k(i,1)^aalpha-policy(i,1);
end

toc

% Simulation 

kt    = 0.9*k_ss;
[C,I] = min(abs(k-kt));

kt1 = zeros(100,1);
ct  = zeros(100,1);

kt1(1,1) = k(I,1);
ct(1,1)  = cpol(I,1);

for ii = 2:length(kt1)
    kt1aux  = find(kt1(ii-1,1)==k);
    kt1(ii) = policy(kt1aux);
    ct(ii)  = A*kt1(ii-1,1)^aalpha-kt1(ii);
end


% VALUE FUNCTION AND GRAPH

figure(5)
plot(k, v1,'k')
title('value function')
xlabel('k')
axis tight
saveas(gcf,'q1_part9_vfn.eps')

% POLICY FUNCTION AND GRAPH

figure(6)
plot(k, policy, 'k')
title('policy function')
xlabel('k')
axis tight
saveas(gcf,'q1_part9_polfn.eps')

figure(7)
plot(kt1)
hold on;
plot(ct,'--k')
title(['Simulation, \beta = ' num2str(bbeta)])
xlabel('t')
legend('Capital Stock','Consumption')
ylim([0 35])
saveas(gcf,'q1_part9_sim.eps')

