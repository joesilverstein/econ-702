% Joseph Silverstein

beta = 1; 
l1 = 1; l2 = 1.6; l3 = 0;
A1 = 100;
gamma = 1.25;
alpha = 0.33;
delta = 0.35;
eta = 1.05;

lambda = eta*gamma^(1/(1-alpha));

capital = zeros(100,1);

% Find K10:
syms K c
c == K + 1;
K10 = solve('');

% initialize capital:
K1 = lambda^(-9)*K10;