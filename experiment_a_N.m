clear;
close all;
Chla_candidates = 0.0104:0.000156667:0.0151;
N_candidates = 15:1:35;
a_candidates = 0:0.01:0.5;
r = 0.05;
Chlb_ = 0.819355422;
Car_ = 0.357771277;
% N_candidates = 19:1:29;    % number of layers

idx = 1;                  % # of row
for N = N_candidates
    for a = a_candidates;
        results(idx).N = N;
        results(idx).r = r;
        results(idx).a = a;
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
        results(idx).Refl = pi_k_A0(1);
        results(idx).Abs = sum(pi_k_Amid);
        results(idx).Trans = pi_k_Alast(1);
        
        
        idx = idx + 1;
    end
end

Ns = cell2mat({results(:).N});
as = cell2mat({results(:).a});
Refl = cell2mat({results(:).Refl});
Abs = cell2mat({results(:).Abs});
Trans = cell2mat({results(:).Trans});

specific_a = 0.2;
specific_N = 25;

figure;
plot(Ns(as==specific_a), Trans(as==specific_a));
xlabel('N'); ylabel('Trans');
ylim([0 0.1])
title('Trans as function of N');
title(sprintf('Trans as function of N.\na = %.3f',specific_a));


figure;
plot(as(Ns==specific_N), Trans(Ns==specific_N));
xlabel('as'); ylabel('Trans');
ylim([0, 0.1]); ylim([0, 1])
title(sprintf('Trans as function of a.\nN = %.0f',specific_N));

Results = struct2cell(results);
Results = squeeze(Results);
Results = cell2mat(Results);
Results = Results';
stepSize = size(a_candidates,2);
% Trans ~ a, along all Ns
for i = 1:stepSize:size(Results,1)
    figure;
    plot(Results(i:i+stepSize-1,3),Results(i:i+stepSize-1,6)) % Trans~a
    ylim([0 0.1 ]); xlim([min(Results(i:i+stepSize-1,3)), max(Results(i:i+stepSize-1,3))]);
    xlabel('a'); ylabel('Trans');
    title(sprintf('N = %.0f',Results(i,1)));
end
% Trans ~ N, along all as
for i = 1:size(a_candidates,2)
    figure;
    plot(N_candidates,Results(Results(:,3) == a_candidates(i),6)) % Trans~N
    ylim([0 0.1 ]);xlim([min(N_candidates), max(N_candidates)]);
    xlabel('N'); ylabel('Trans');
    title(sprintf('a = %.3f',Results(i,3)));
end
