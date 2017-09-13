% 1. build elementary r
% 2. build elementary a from concentrations and epsilons
% 3. calculate the number of layers N (natural) from concentration
% 4. build transition matrix from N,a,r (and SS matrix)
% 5. calculate and compare analytical and brute force solutions
clear;
clc;
close all;

Params = get_default_parameters();

Chla_candidates = [0.002:0.00011:0.012]; % random
% [0.0020804557322146:0.00052011393:0.0152] int from below
% [0.0020804557322148:0.00052011395:0.0152] int from above

idx = 1;
for chla = Chla_candidates
    Params.Chla = chla;
    [Nreal, N, p_encount, Refl, Abso, Tran] = main(Params);
    
    results(idx).a = get_a(Params);
    results(idx).r = get_r(Params);
    results(idx).chla = chla;
    results(idx).Nreal = Nreal;
    results(idx).N = N;
    results(idx).p_encount = p_encount;
    results(idx).Refl = Refl;
    results(idx).Abso = Abso;
    results(idx).Tran = Tran;

    
    idx = idx + 1;
end % end chla
