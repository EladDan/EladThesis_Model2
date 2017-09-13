clear;
clc;
close all;

Params = get_default_parameters();
[Params.a_red, ~] = get_a(Params);

N_candidates = [5:15]; % chla = [2.5:7.5] % mg/L


idx = 1;
for N = N_candidates
    Params.N = N;
    [ Refl, Abso, Tran ] = get_analytical_results2( Params );
    
    if round(Refl+Abso+Tran,10) < 1
        fprintf('ERROR, sum of results equals to %.10f.\n',Refl+Abso+Tran);
        fprintf('       Case: N = %.0f\n',N);
    end
    
    results(idx).a = get_a(Params);
    results(idx).r = get_r(Params);
    results(idx).chla = N/2;
    results(idx).Nreal = -999;
    results(idx).N = N;
    results(idx).p_encount = 1;
    results(idx).Refl = Refl;
    results(idx).Abso = Abso;
    results(idx).Tran = Tran;
    
    idx = idx + 1;
end % end N


results = struct2matrix(results);
save('1_anal.mat', 'results');



