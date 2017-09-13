% 1. build elementary r
% 2. build elementary a from concentrations and epsilons
% 3. calculate the number of layers N (natural) from concentration
% 4. build transition matrix from N,a,r (and SS matrix)
% 5. calculate and compare analytical and brute force solutions
clear;
clc;
close all;
addpath(genpath('./../model1/'));

Params = get_default_parameters();
[r_red, ~] = get_r(Params);
r = r_red;
[a_red, ~] = get_a(Params);
a = a_red;

results = struct();

Nreal_candidates = [5:0.2:7, 7.33:0.33:10, 10.5:0.5:15];

N_max = 500;
N = N_max;
% Chla_candidates = 0.002:0.00011:0.015;
% [0.0020804557322146:0.00052011393:0.0152] int from below
% [0.0020804557322148:0.00052011395:0.0152] int from above
% step = 1;
% N_max_candidates = ceil(Nreal):step:70;               % variable integer numbers for N

M = 11; % 2^M for rasing the matrix at power
idx = 1;
for Nreal = Nreal_candidates
    p_encount = Nreal/N;
    fprintf('build_transition_mat for N = %.0f\n', N);
    Transition_mat = build_transition_mat(N, r, a, p_encount);
    validate_transition_mat(Transition_mat,0); % 0 - do not print if all ok
    disp('get_SS_results');
    [Refl, Abso, Tran] = get_SS_results(Transition_mat,M);
    while ~(round(Refl+Abso+Tran,10) == 1)
        fprintf('ERROR, sum of results equals to %.10f. M = %.0f\n',Refl+Abso+Tran,M);
        fprintf('       Case: N = %.0f, Nreal = %.10f, p_encount = %.10f.\n',N, Nreal, p_encount);
        M = M+1;
        [Refl, Abso, Tran] = get_SS_results(Transition_mat,M);
    end
    %     if ~(round(Refl+Abso+Tran,10) == 1)
    %         fprintf('ERROR, sum of results equals to %.10f\n',Refl+Abso+Tran);
    %         fprintf('       Case: N = %.0f, Nreal = %.10f, p_encount = %.10f.\n',N, Nreal, p_encount);
    %         flag = true;
    %         disp('get_SS_results, flag = true');
    %         [Refl, Abso, Tran, power] = get_SS_results(Transition_mat,flag);
    %         flag = false;
    %         return
    %     else
    %         fprintf('All good, sum of results equals to %.10f\n',Refl+Abso+Tran);
    %         fprintf('          Case: N = %.0f, Nreal = %.10f, p_encount = %.10f.\n',N, Nreal, p_encount);
    %     end
    
    
    results(idx).a = get_a(Params);
    results(idx).r = get_r(Params);
    %     results(idx).chla = chla;
    results(idx).Nreal = Nreal;
    results(idx).N = N;
    results(idx).p_encount = p_encount;
    results(idx).Refl = Refl;
    results(idx).Abso = Abso;
    results(idx).Tran = Tran;
    results(idx).M = M;
    
    
    idx = idx + 1;
end % end N
results = struct2matrix(results);
file_name = strcat('2_power_', num2str(N_max), '.mat');
save(file_name, 'results');

