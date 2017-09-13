% 1. build elementary r
% 2. build elementary a from concentrations and epsilons
% 3. calculate the number of layers N (natural) from concentration
% 4. build transition matrix from N,a,r (and SS matrix)
% 5. calculate and compare analytical and brute force solutions
function [Nreal, N, p_encount, Refl, Abso, Tran] = main(Params)
% INPUTs
if ~(exist('Params', 'var'))
    Params = get_default_parameters();
end
% override parameters
% Params.Chla = 0.010402;

[r_red, ~] = get_r(Params);
r = r_red;

[a_red, ~] = get_a(Params);
a = a_red;

[N, Nreal, p_encount] = get_number_layers(Params);

Transition_mat = build_transition_mat(N, r, a, p_encount);

validate_transition_mat(Transition_mat);

[Refl, Abso, Tran] = get_SS_results(Transition_mat);

if ~(round(Refl+Abso+Tran,10) == 1)
    fprintf('ERROR, sum of results equals to %.10f\n',Refl+Abso+Tran);
    fprintf('       Case: N = %.0, Nreal = %.10f, p_encount = %.10f.\n',N, Nreal, p_encount);
    return
else
   fprintf('All good, sum of results equals to %.10f\n',Refl+Abso+Tran);
   fprintf('          Case: N = %.0f, Nreal = %.10f, p_encount = %.10f.\n',N, Nreal, p_encount);
end

disp('Main ran successfully');
end
