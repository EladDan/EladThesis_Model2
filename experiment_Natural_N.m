clear;
close all;

N_candidates = 2:1:20;    % number of layers
r = 0.05;
a = 0.92;
t = (1-r)*(1-a);

idx = 1;                  % # of row

for N = N_candidates
    results(idx).N = N;
    [~, ~, transition_mat ] = AbsorptionProbs(N, r, a);
    
    I = eye(2*N-1);                          % Identity matrix (Partial down-right of transition_mat)
    P_ = transition_mat(1:2*N-1,1:2*N-1);    % Partial up-left of transition_mat
    eta = build_eta(N, r, a);
    
    % find the steady-state probabilities to move from state k to state l=Aj
    % A0 <=> reflected out
    pi_k_A0 = (I-P_)\eta(:,1);               % inv(I-P_) * eta(:,1) when j=1 <=> A(0)
    for j = 2:N+1
        temp = (I-P_)\eta(:,j);              % inv(I-P_) * eta(:,j) when j <=> A(j-1)
        pi_k_Amid(j-1) = temp(1);
    end
    % AN+1 <=> transmitted out
    pi_k_Alast = (I-P_)\eta(:,N+2);          % inv(I-P_)* eta(:,N+2) when j=N+2 <=> A(N+1)
    
    % save results
    results(idx).r = r;
    results(idx).a = a;
    results(idx).Refl = pi_k_A0(1);
    results(idx).Abs = sum(pi_k_Amid);
    results(idx).Trans = pi_k_Alast(1);
    
    idx = idx + 1;
end


Ns = cell2mat({results(:).N});
Refl = cell2mat({results(:).Refl});
Abs = cell2mat({results(:).Abs});
Trans = cell2mat({results(:).Trans});

% p = plot(Ns, Refl);
% set(p, 'XDataSource', num2str(Refl,'%.7f'));
% refresh

figure;
plot(Ns, Refl);
xlabel('N'); ylabel('Reflection');
title('Reflection as function of N');

figure;
plot(Ns, Abs);
xlabel('N'); ylabel('Absorbance');
title('Absorbance as function of N');

figure;
plot(Ns, Trans);
xlabel('N'); ylabel('Transmittance');
title('Transmittance as function of N');

