clear;
close all;

alpha=0.3; beta=0.6; A=20; maxit=3; nk = 5; tol=10^-4;

kss = (alpha*beta*A)^(1/(1-alpha));
gridk = zeros(nk,1);
for i=1:nk;
    gridk(i)=(1+0.1*(i-3))*kss;
end;

soln_q1n4 = value3(gridk, nk, maxit, tol, alpha, beta, A);

maxit = 1000;
soln_q1n5 = value3(gridk, nk, maxit, tol, alpha, beta, A);

nk = 201;
gridk = zeros(nk,1);
for i=1:nk;
    gridk(i)=(1+(0.2/100)*(i-101))*kss;
end;

soln_q1n6 = value3(gridk, nk, maxit, tol, alpha, beta, A);

k0 = 0.9*kss; % initial capital stock
soln_q1n7 = capital(k0, alpha, beta, A);

beta = 0.85;
kss = (alpha*beta*A)^(1/(1-alpha));
k0 = 0.9*kss; % new initial capital because new steady state
nk = 201;
gridk = zeros(nk,1);
for i=1:nk;
    gridk(i)=(1+(0.2/100)*(i-101))*kss;
end;
soln_q1n8_rpt6 = value3(gridk, nk, maxit, tol, alpha, beta, A);
soln_q1n8_rpt7 = capital(k0, alpha, beta, A);

sigma = 3;
% Use the steady state computed in the benchmark case for part 8
[soln_q1n9_rpt6, soln_q1n9_rpt7] = valueCRRA(gridk, nk, maxit, tol, alpha, beta, A, sigma, k0);

%% Part 2:

A = 2; beta = 0.6; k0 = 0.04; nk=201; maxit=1000;
gridk = linspace(0,0.05,nk);
clear soln_q2n6;
[soln_q2n6, soln_q2n7] = valueGHH2(gridk, nk, maxit, tol, alpha, beta, A, k0);
