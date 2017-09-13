clear;
Chla_candidates = 0.001:0.001:0.020;    % mg/cm3   
idx = 1;                                % # of row
% results = zeros(size(Chla_candidates,2),14);
for Chla = Chla_candidates
    [N, r_red, r_blue, a_red, a_blue, rX, bX] = getNumberLayers(Chla);
    N = ceil(N);
    if (N <= 1)
        N = 2;
    end
    
    % save red results
    results(idx).Chla = Chla;
    results(idx).N = N;
    
    % red
    r = r_red;
    a = a_red;
    t = (1-r)*(1-a);
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
    
    disp(pi_k_A0(1));                        % total reflected light/incident light
    disp(sum(pi_k_Amid));                    % total absorbed light/incident light
    disp(pi_k_Alast(1));                     % total transmitted light/incident light
    
    % save red results
    results(idx).r_red = r;
    results(idx).a_red = a;
    results(idx).t_red = t;
    results(idx).Refl_red = pi_k_A0(1);
    results(idx).Abs_red = sum(pi_k_Amid);
    results(idx).PAR_Trans_red = pi_k_Alast(1)*rX^2;
    
    
    % blue
    r = r_blue;
    a = a_blue;
    t = (1-r)*(1-a);
    [~, ~, transition_mat ] = AbsorptionProbs(N, r, a);
    
    I = eye(2*N-1);
    P_ = transition_mat(1:2*N-1,1:2*N-1);
    eta = build_eta(N, r, a);
    
    % find the "final" probabilities to move from state 1 to state Aj
    pi_k_A0 = inv(I-P_) * eta(:,1);
    for j = 2:N+1
        temp = inv(I-P_) * eta(:,j);
        pi_k_Amid(j-1) = temp(1);
    end
    pi_k_Alast = inv(I-P_)* eta(:,N+2);
    
    disp(pi_k_A0(1)); % total reflected light/incident light
    disp(sum(pi_k_Amid)); % total absorbed light/incident light
    disp(pi_k_Alast(1)); % total transmitted light/incident light
    
    % save blue results
    results(idx).r_blue = r;
    results(idx).a_blue = a;
    results(idx).t_blue = t;
    results(idx).Refl_blue = pi_k_A0(1);
    results(idx).Abs_blue = sum(pi_k_Amid);
    results(idx).PAR_Trans_blue = pi_k_Alast(1)*bX^2;
    
    idx = idx + 1;
end