% 1. build elementary r
% 2. build elementary a from concentrations and epsilons
% 3. calculate the number of layers N (natural) from concentration
% 4. build transition matrix from N,a,r (and SS matrix)
% 5. calculate and compare analytical and brute force solutions
clear;
clc;
close all;

showResults = 0;

Params = get_default_parameters();
[Params.a_red, ~] = get_a(Params);

% % manualy change the parameters
% Params.a_red = 0.665;
% Params.r_red = 0.0;
% chla_candidates = [0.002:0.00011:0.015]

N_candidates = [5:15]; % chla = [2.5:7.5] % mg/L
p_encount_default = 1;

idx = 1;
for N = N_candidates
    
    [ Transition_mat ] = build_transition_mat( N, Params.r_red, Params.a_red, p_encount_default);
    [ Refl, Abso, Tran ] = get_SS_results( Transition_mat );
    if ~(round(Refl+Abso+Tran,10) == 1)
        fprintf('ERROR, sum of results equals to %.10f.\n',Refl+Abso+Tran);
        fprintf('       Case: N = %.0f\n',N);
        [Refl, Abso, Tran] = get_SS_results(Transition_mat);
    end
    
    results(idx).a = get_a(Params);
    results(idx).r = get_r(Params);
    results(idx).chla = N/2;
    results(idx).Nreal = -999;
    results(idx).N = N;
    results(idx).p_encount = p_encount_default;
    results(idx).Refl = Refl;
    results(idx).Abso = Abso;
    results(idx).Tran = Tran;
    
    idx = idx + 1;
end % end N
results = struct2matrix(results);
save('1_power.mat', 'results');

if (showResults == 1)
    
    Results = struct2matrix(results);
    
    % PBRresults(:).N = [0.27, 0.82, 1.35, 2.36, 3.31, 4.21];
    % PBRresults(:).Tran = [0.00389, 0.00230, 0.00136, 0.00050, 0.00020, 0.00009];
    
    PBRresults(:).N = [0.82, 1.35, 2.36, 3.31, 4.21];
    PBRresults(:).Tran = [0.00230, 0.00136, 0.00050, 0.00020, 0.00009];
    
    PBRResults = struct2matrix(PBRresults);
    
    % x1 = [results(:).N];
    % x2  = [PBRresults(:).N];
    % figure;
    % plot(x1,[results(:).Tran],'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r')
    % hold
    % plot(x2, PBRresults(:).Tran, 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
    
    figure;
    plot([1:length([results(:).Tran])],[results(:).Tran]);
    hold
    plot([1:length(PBRresults(:).Tran)], PBRresults(:).Tran);
end