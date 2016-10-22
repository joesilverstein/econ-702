clear all;
close all;

alpha=0.3;
beta=0.6;
A=20;
maxit=3;
nk = 5;
tol=10^-4;

kss = (alpha*beta*A)^(1/(1-alpha));
gridk = zeros(nk,1);
for i=1:nk;
    gridk(i)=(1+0.1*(i-3))*kss;
end;

soln_q1n4 = value(gridk, nk, maxit, tol, alpha, beta, A);

maxit = 1000;
soln_q1n5 = value(gridk, nk, maxit, tol, alpha, beta, A);

nk = 201;
gridk = zeros(nk,1);
for i=1:nk;
    gridk(i)=(1+(0.2/100)*(i-101))*kss;
end;

soln_q1n6 = value(gridk, nk, maxit, tol, alpha, beta, A);

k0 = 0.9*kss; % initial capital stock
soln_q1n7 = zeros(101,2);
soln_q1n7(1,2) = k0;
k = k0;
for t=1:100;
    k = alpha*beta*A*k^alpha;
    soln_q1n7(t+1,2) = k;
    
    soln_q1n7(t,1) = A*soln_q1n7(t,2)^alpha - k; % consumption c_t
end;
soln_q1n7(101,1) = soln_q1n7(100,1); % fill in last entry
