clear;
close all;

%% 1.4 %%

maxit=400; 
nb = 500; nd = 20;
tol=0.1;

maxb = 10; maxd = 1.0;
gridb = linspace(0,maxb,nb);
gridd = linspace(0,maxd,nd);
z = 0.1;
turb = 1;
ojs = 0; % no on-the-job search

tic
soln_q4 = value_JFV_hw3(gridb, gridd, nb, nd, maxit, tol, z, turb, ojs);
toc

save('soln_q4'); % saved for nb=500, nd=20, tol=0.1

% graymon; % forces MATLAB to print plots in grayscale

figure(1)
hold on
title('Savings Policy Functions')
xlabel('Current Savings')
ylabel('Next Savings')
plot(gridb,soln_q4(:,2),gridb,soln_q4(:,3),gridb,soln_q4(:,4),gridb,soln_q4(:,5),gridb,soln_q4(:,6),gridb,soln_q4(:,7))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1','Unemployed','Location','northwest')
hold off
print('fig1','-dpng');

figure(2)
hold on
title('Diligence Policy Functions')
xlabel('Current Savings')
ylabel('Current Diligence')
plot(gridb,soln_q4(:,8),gridb,soln_q4(:,9),gridb,soln_q4(:,10),gridb,soln_q4(:,11),gridb,soln_q4(:,12))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1')
hold off
print('fig2','-dpng');

figure(3)
hold on
title('Search Effort Policy Function')
xlabel('Current Savings')
ylabel('Current Search Effort')
plot(gridb,soln_q4(:,13))
print('fig3','-dpng');
hold off

% Determine which wage offers the agent will accept:

vfuns = cell(6,1); % value of being employed at wage i
vfuns{1} = soln_q4(:,14);
vfuns{2} = soln_q4(:,15);
vfuns{3} = soln_q4(:,16);
vfuns{4} = soln_q4(:,17);
vfuns{5} = soln_q4(:,18);
vfuns{6} = soln_q4(:,19);

figure(4)
hold on
title('Value Functions')
xlabel('Savings')
ylabel('Value')
plot(gridb,vfuns{1},gridb,vfuns{2},gridb,vfuns{3},gridb,vfuns{4},gridb,vfuns{5},gridb,vfuns{6})
legend('W_1(b)','W_2(b)','W_3(b)','W_4(b)','W_5(b)','U(b)')
hold off
print('fig4','-dpng')

% Determine where W_1(b)==U(b)
for bc=1:nb
    if vfuns{1}(bc)<vfuns{6}(bc)
        disp(gridb(bc))
        break;
    end;
end

%% 1.5 %%

nagents = 1000;
nperiods = 1000;
soln_q5 = simulation(nagents,nperiods,gridb,maxb,nb,soln_q4,turb);
save('soln_q5');

savings = soln_q5(:,1);
figure(5)
hold on
title('Histogram of Savings')
xlabel('Assets')
ylabel('Frequency')
hist(savings,50) % distribution of assets (~chi-squared)
hold off
print('fig5','-dpng')

state = soln_q5(:,2);
unemployed = zeros(nagents,1); % 0=employed, 1=unemployed
for i=1:nagents
    if state(i) ~= 0
        unemployed(i) = 1;
    end
end
mean(unemployed) % unemployment rate

j=1;
for i=1:nagents
    if state(i)~=0
        wageStates(j) = state(i);
        j = j + 1;
    end
end
tabulate(wageStates) % distribution of wages

%% 1.6 %%

% (a) %
z = 0.05;
tic
soln_q6a = value_JFV_hw3(gridb, gridd, nb, nd, maxit, tol, z, turb, ojs);
toc
save('soln_q6a');

figure(6)
hold on
title('Savings Policy Functions')
xlabel('Current Savings')
ylabel('Next Savings')
plot(gridb,soln_q6a(:,2),gridb,soln_q6a(:,3),gridb,soln_q6a(:,4),gridb,soln_q6a(:,5),gridb,soln_q6a(:,6),gridb,soln_q6a(:,7))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1','Unemployed','Location','northwest')
hold off
print('fig6','-dpng');

figure(7)
hold on
title('Diligence Policy Functions')
xlabel('Current Savings')
ylabel('Current Diligence')
plot(gridb,soln_q6a(:,8),gridb,soln_q6a(:,9),gridb,soln_q6a(:,10),gridb,soln_q6a(:,11),gridb,soln_q6a(:,12))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1')
hold off
print('fig7','-dpng');

figure(8)
hold on
title('Search Effort Policy Function')
xlabel('Current Savings')
ylabel('Current Search Effort')
plot(gridb,soln_q6a(:,13))
print('fig8','-dpng');

turb = 1;
soln_q6a_sim = simulation(nagents,nperiods,gridb,maxb,nb,soln_q6a,turb);

savings = soln_q6a_sim(:,1);
figure(9)
hold on
title('Histogram of Savings')
xlabel('Assets')
ylabel('Frequency')
hist(savings,50) % distribution of assets (~chi-squared)
hold off
print('fig9','-dpng')

state = soln_q6a_sim(:,2);
unemployed = zeros(nagents,1); % 0=employed, 1=unemployed
for i=1:nagents
    if state(i) ~= 0
        unemployed(i) = 1;
    end
end
mean(unemployed) % unemployment rate

j=1;
for i=1:nagents
    if state(i)~=0
        wageStates(j) = state(i);
        j = j + 1;
    end
end
tabulate(wageStates) % distribution of wages

% (b) %
z = 0.15;
tic
soln_q6b = value_JFV_hw3(gridb, gridd, nb, nd, maxit, tol, z, turb, ojs);
toc
save('soln_q6b');

figure(10)
hold on
title('Savings Policy Functions')
xlabel('Current Savings')
ylabel('Next Savings')
plot(gridb,soln_q6b(:,2),gridb,soln_q6b(:,3),gridb,soln_q6b(:,4),gridb,soln_q6b(:,5),gridb,soln_q6b(:,6),gridb,soln_q6b(:,7))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1','Unemployed','Location','northwest')
hold off
print('fig10','-dpng');

figure(11)
hold on
title('Diligence Policy Functions')
xlabel('Current Savings')
ylabel('Current Diligence')
plot(gridb,soln_q6b(:,8),gridb,soln_q6b(:,9),gridb,soln_q6b(:,10),gridb,soln_q6b(:,11),gridb,soln_q6b(:,12))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1')
hold off
print('fig11','-dpng');

figure(12)
hold on
title('Search Effort Policy Function')
xlabel('Current Savings')
ylabel('Current Search Effort')
plot(gridb,soln_q6b(:,13))
print('fig12','-dpng');

turb = 1;
soln_q6b_sim = simulation(nagents,nperiods,gridb,maxb,nb,soln_q6b,turb);

savings = soln_q6b_sim(:,1);
figure(13)
hold on
title('Histogram of Savings')
xlabel('Assets')
ylabel('Frequency')
hist(savings,50) % distribution of assets (~chi-squared)
hold off
print('fig13','-dpng')

state = soln_q6b_sim(:,2);
unemployed = zeros(nagents,1); % 0=employed, 1=unemployed
for i=1:nagents
    if state(i) ~= 0
        unemployed(i) = 1;
    end
end
mean(unemployed) % unemployment rate

j=1;
for i=1:nagents
    if state(i)~=0
        wageStates(j) = state(i);
        j = j + 1;
    end
end
tabulate(wageStates) % distribution of wages

%% 1.7 %%

turb = 0.5;
z = 0.1;
tic
soln_q7 = value_JFV_hw3(gridb, gridd, nb, nd, maxit, tol, z, turb, ojs);
toc
save('soln_q7');

figure(14)
hold on
title('Savings Policy Functions')
xlabel('Current Savings')
ylabel('Next Savings')
plot(gridb,soln_q7(:,2),gridb,soln_q7(:,3),gridb,soln_q7(:,4),gridb,soln_q7(:,5),gridb,soln_q7(:,6),gridb,soln_q7(:,7))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1','Unemployed','Location','northwest')
hold off
print('fig14','-dpng');

figure(15)
hold on
title('Diligence Policy Functions')
xlabel('Current Savings')
ylabel('Current Diligence')
plot(gridb,soln_q7(:,8),gridb,soln_q7(:,9),gridb,soln_q7(:,10),gridb,soln_q7(:,11),gridb,soln_q7(:,12))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1')
hold off
print('fig15','-dpng');

figure(16)
hold on
title('Search Effort Policy Function')
xlabel('Current Savings')
ylabel('Current Search Effort')
plot(gridb,soln_q7(:,13))
print('fig16','-dpng');

turb = 1;
soln_q7_sim = simulation(nagents,nperiods,gridb,maxb,nb,soln_q7,turb);

savings = soln_q7_sim(:,1);
figure(17)
hold on
title('Histogram of Savings')
xlabel('Assets')
ylabel('Frequency')
hist(savings,50) % distribution of assets (~chi-squared)
hold off
print('fig17','-dpng')

state = soln_q7_sim(:,2);
unemployed = zeros(nagents,1); % 0=employed, 1=unemployed
for i=1:nagents
    if state(i) ~= 0
        unemployed(i) = 1;
    end
end
mean(unemployed) % unemployment rate

j=1;
for i=1:nagents
    if state(i)~=0
        wageStates(j) = state(i);
        j = j + 1;
    end
end
tabulate(wageStates) % distribution of wages

%% 1.8 %%

ojs = 1;
nb = 500; nd = 20;
tol=0.1;
turb=1;
z=0.1;
maxit=100;
maxb = 10; maxd = 1.0;
gridb = linspace(0,maxb,nb);
gridd = linspace(0,maxd,nd);
soln_q8 = value_JFV_hw3(gridb, gridd, nb, nd, maxit, tol, z, turb, ojs);
save('soln_q8');

soln_q8_sim = simulation_s(nagents, nperiods, gridb, maxb, nb, soln_q8, turb);

figure(18)
hold on
title('Savings Policy Functions')
xlabel('Current Savings')
ylabel('Next Savings')
plot(gridb,soln_q8(:,2),gridb,soln_q8(:,3),gridb,soln_q8(:,4),gridb,soln_q8(:,5),gridb,soln_q8(:,6),gridb,soln_q8(:,7))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1','Unemployed','Location','northwest')
hold off
print('fig18','-dpng');

figure(19)
hold on
title('Diligence Policy Functions')
xlabel('Current Savings')
ylabel('Current Diligence')
plot(gridb,soln_q8(:,8),gridb,soln_q8(:,9),gridb,soln_q8(:,10),gridb,soln_q8(:,11),gridb,soln_q8(:,12))
legend('w=0.2','w=0.4','w=0.6','w=0.8','w=1')
hold off
print('fig19','-dpng');

figure(20)
hold on
title('Search Effort Policy Function')
xlabel('Current Savings')
ylabel('Current Search Effort')
plot(gridb,soln_q8(:,13))
print('fig20','-dpng');

turb = 1;
soln_q8_sim = simulation(nagents,nperiods,gridb,maxb,nb,soln_q8,turb);

savings = soln_q8_sim(:,1);
figure(21)
hold on
title('Histogram of Savings')
xlabel('Assets')
ylabel('Frequency')
hist(savings,50) % distribution of assets (~chi-squared)
hold off
print('fig21','-dpng')

state = soln_q8_sim(:,2);
unemployed = zeros(nagents,1); % 0=employed, 1=unemployed
for i=1:nagents
    if state(i) ~= 0
        unemployed(i) = 1;
    end
end
mean(unemployed) % unemployment rate

j=1;
for i=1:nagents
    if state(i)~=0
        wageStates(j) = state(i);
        j = j + 1;
    end
end
tabulate(wageStates) % distribution of wages