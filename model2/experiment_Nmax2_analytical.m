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
results = struct();
% chla = 0.01;
% Nreal = 19.01;
Nreal_candidates = [5:0.2:7, 7.33:0.33:10, 10.5:0.5:15];
N_max = 8;
N = N_max;
% Chla_candidates = 0.002:0.00011:0.015;
% [0.0020804557322146:0.00052011393:0.0152] int from below
% [0.0020804557322148:0.00052011395:0.0152] int from above
% step = 1;
% N_max_candidates = ceil(Nreal):step:70;               % variable integer numbers for N
Params.N = N;
[Params.a_red, ~] = get_a(Params);

idx = 1;
for Nreal = Nreal_candidates
    [ Refl, Abso, Tran ] = get_analytical_results2( Params, Nreal );

    if ~(round(Refl+Abso+Tran,10) == 1)
        fprintf('ERROR, sum of results equals to %.10f\n',Refl+Abso+Tran);
        fprintf('       Case: N = %.0f, Nreal = %.10f\n',N, Nreal);
    end
    
    results(idx).a = get_a(Params);
    results(idx).r = get_r(Params);
%     results(idx).chla = chla;
    results(idx).Nreal = Nreal;
    results(idx).N = N;
    results(idx).p_encounter = Nreal/N;
    results(idx).Refl = Refl;
    results(idx).Abso = Abso;
    results(idx).Tran = Tran;

    idx = idx + 1;
end % end N
results = struct2matrix(results);
file_name = strcat('2_anal_', num2str(N_max), '.mat');
save(file_name, 'results');

