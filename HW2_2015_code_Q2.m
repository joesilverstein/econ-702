% This m-file solves the numerics of problem set 2, question 2
% Coded by Cezar Santos, Pilar Alcalde, and Devin Reilly
clear all; clc; close all;

tic                     % initializing the timer

% PARAMETERS  
aalpha = 0.3; 
bbeta = 0.6;
A = 2;
max_iter = 10000;
tol = 1.0e-6;
n_grid = 120;           % numbers of elements in the grid, changes in different questions

% % % % A = (1/(bbeta*aalpha))^aalpha*(1-aalpha)^(aalpha-1);

% PRELIMINARIES
% 1. Set the grid for this period's capital. For questions 4 and 5, it
% would be (n_grid=6)
% k = linspace(1,11,n_grid)';
% and for questions 6, 7, and 8, it would be (n_grid)=220
% k = linspace(0.05,11,n_grid)';

k = linspace(0.04,0.2,n_grid)';     

% 2. Compute this period's utility for each k, k'
%    This will be useful in the actual iteration (the flow utilities will
%    never change in the iteration even as the value function updates).
%    Note: We use our FOC w.r.t. labor supply n to get closed form
%    of n in terms of k: n = ((1-alpha)*A)^(1/alpha)*k gives our optimal
%    labor supply for any given k. Then we substitute in for it, and
%    can solve just for optimal k'.
utility = zeros(n_grid, n_grid);
cons = zeros(n_grid, n_grid);
for ii = 1:n_grid       %Today's capital
    for jj = 1:n_grid   %Tomorrow's capital
        help = A * (k(ii)^aalpha)*(((1-aalpha)*A)^(1/aalpha)*k(ii)).^(1-aalpha) -...
            k(jj) - ((1-aalpha)*A)^(1/aalpha)*k(ii);  %Calculate implied consumption
        if help > 0             %If consumption positive, flow utility
            utility(ii,jj) = log(help);
        else                    %If cons <= 0, penalize with a large number
            utility(ii,jj) = -99999;
        end
        
        cons(ii,jj) = A * (k(ii)^aalpha)*(((1-aalpha)*A)^(1/aalpha)*k(ii)).^(1-aalpha) - k(jj);
        if cons <= 0
            utility(ii,jj)= -99999;
        end
    end
end

% 3. Value function iteration
iter = 0;                % Start iteration number at 0
diff = tol + 1;          % To make sure loop actually starts
v0 = zeros(n_grid,1);    % Initial guess for the value function
v_possible = zeros(n_grid, n_grid);
while diff > tol  &&  iter < max_iter
    iter = iter + 1;
    v_possible = utility + bbeta*ones(n_grid,1)*v0';
    [v1 ind] = max(v_possible,[],2);
    kpolicy = k(ind);
    npolicy = ((1-aalpha)*A)^(1/aalpha)*k;
    diff = max(abs(v1 - v0));
    v0 = v1;
end

% VALUE FUNCTION AND GRAPH
figure(1)
plot(k, v1)
title('Value Function - Numerical')
xlabel('k')
ylabel('value')

% CAPITAL POLICY FUNCTION AND GRAPH
figure(2)
plot(k, kpolicy)
hold on;
plot(k, k, 'k--')
title('Capital Policy Function  - Numerical')
xlabel('k')
ylabel('kprime')

% LABOR POLICY FUNCTION AND GRAPH
figure(3)
plot(k, npolicy)
title('Labor Policy Function  - Numerical')
xlabel('k')
ylabel('labor supply')

cpol = A*npolicy.^(1-aalpha).*k.^aalpha - kpolicy;

% CONSUMPTION POLICY FUNCTION AND GRAPH
figure(4)
plot(k, cpol)
title('Consumption Policy Function  - Numerical')
xlabel('k')
ylabel('consumption')

% Simulation 

kt    = 0.04;
[C,I] = min(abs(k-kt));

kt1 = zeros(50,1);
ct  = zeros(50,1);

kt1(1,1) = kpolicy(I,1);
ct(1,1)  = cpol(I,1);

for ii = 2:length(kt1)
    kt1aux  = find(kt1(ii-1,1)==k);
    kt1(ii) = kpolicy(kt1aux);
    ct(ii)  = A*kt1(ii-1,1)^aalpha-kt1(ii);
end

