
%% compare between raising to high power vs. analytical solution
clc;
clear;
close all;
addpath(genpath('./../model2/'));

% load model 1 results
results_N_integer_power = load('1_power.mat');
results_N_integer_power = results_N_integer_power.results;

results_N_integer_analytical = load('1_anal.mat');
results_N_integer_analytical = results_N_integer_analytical.results;

% load model 2 results
results_N_real_power = load('2_power_500.mat');
results_N_real_power = results_N_real_power.results;

results_N_real_analytical = load('2_anal_500.mat');
results_N_real_analytical = results_N_real_analytical.results;

% plot models
% figure;
figure('Position', [100, 100, 650,500])
% model 1 (column 5 - N, column 9 - Trans) 
plot(results_N_integer_power(:,5),results_N_integer_power(:,9), 'b-o','MarkerFaceColor','b','MarkerSize',8);
hold on;
plot(results_N_integer_analytical(:,5),results_N_integer_analytical(:,9),'b^','MarkerSize',14,'LineWidth', 1.5);
% model 2 (column 3 - N, column 8 - Trans) 
plot(results_N_real_power(:,3),results_N_real_power(:,8), 'ro','MarkerFaceColor','r','MarkerSize',8);
plot(results_N_real_analytical(:,3),results_N_real_analytical(:,8),'r^','MarkerSize',14,'LineWidth', 1.5);

xlabel('N'); ylabel('Total Transmission');
% title(sprintf('Raise power vs. analytical solution'));
set(gca,'FontWeight','bold');
set(gca,'fontsize',12);
legend('model1-power','model1-analytical','model2-power','model2-analytical');


%% compare between model 2 (and model 1): different N_max
clc;
clear;
close all;
addpath(genpath('./../model2/'));
% load model 1 results
results_N_integer_analytical = load('1_anal.mat');
results_N_integer_analytical = results_N_integer_analytical.results;

% load models 2 results
results_N_real_15 = load('2_anal_15.mat');
results_N_real_15 = results_N_real_15.results;

results_N_real_30 = load('2_anal_30.mat');
results_N_real_30 = results_N_real_30.results;

results_N_real_3000 = load('2_anal_3000.mat');
results_N_real_3000 = results_N_real_3000.results;

% plot models
figure('Position', [100, 100, 650,500])
% model 1 (column 5 - N, column 9 - Trans) 
plot(results_N_integer_analytical(:,5),results_N_integer_analytical(:,9), 'b-^','MarkerSize',8);
hold on;
% model 2 (column 3 - N, column 8 - Trans) 
plot(results_N_real_15(:,3),results_N_real_15(:,8), 'r-^','MarkerSize',8);
plot(results_N_real_30(:,3),results_N_real_30(:,8),'r-^','MarkerFaceColor','r','MarkerSize',8);
plot(results_N_real_3000(:,3),results_N_real_3000(:,8),'r--^','MarkerEdgeColor','r','MarkerSize',8);


xlabel('N'); ylabel('Total Transmission');
% title(sprintf('Raise power vs. analytical solution'));
set(gca,'FontWeight','bold');
set(gca,'fontsize',12);
legend('model1','model2-15','model2-30','model2-3000');





% l = legend('model 2 (N_max=50)','model 2 (N_max=1500)');
% set(l, 'Interpreter', 'none');



