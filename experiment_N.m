clear;
close all;
Chla_candidates = 0.0104:0.000156667:0.0151;
Chlb_ = 0.819355422;
Car_ = 0.357771277;
% N_candidates = 19:1:29;    % number of layers

idx = 1;                  % # of row
for Chla = Chla_candidates
    [Nreal, N , r_red, r_blue, a_red, a_blue] = getNumberLayers(Chla, Car_,Chlb_);
    results(idx).Chla = Chla;
    results(idx).Nreal = Nreal;
    results(idx).N = N;
    
    % Red
    results(idx).r_red = r_red;
    results(idx).a_red = a_red;
    [~, ~, transition_mat ] = AbsorptionProbs(N, r_red, a_red);
    I = eye(2*N-1);                          % Identity matrix (Partial down-right of transition_mat)
    P_ = transition_mat(1:2*N-1,1:2*N-1);    % Partial up-left of transition_mat
    eta = build_eta(N, r_red, a_red);
    
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
    results(idx).Refl_red = pi_k_A0(1);
    results(idx).Abs_red = sum(pi_k_Amid);
    results(idx).Trans_red = pi_k_Alast(1);
    
    % Blue
    results(idx).r_blue = r_blue;
    results(idx).a_blue = a_blue;
    [~, ~, transition_mat ] = AbsorptionProbs(N, r_blue, a_blue);
    I = eye(2*N-1);                          % Identity matrix (Partial down-right of transition_mat)
    P_ = transition_mat(1:2*N-1,1:2*N-1);    % Partial up-left of transition_mat
    eta = build_eta(N, r_blue, a_blue);
    
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
    results(idx).Refl_blue = pi_k_A0(1);
    results(idx).Abs_blue = sum(pi_k_Amid);
    results(idx).Trans_blue = pi_k_Alast(1);
    idx = idx + 1;
end

Nreals = cell2mat({results(:).Nreal});
Ns = cell2mat({results(:).N});
Chlas = cell2mat({results(:).Chla});
r_red = cell2mat({results(:).r_red});
a_red = cell2mat({results(:).a_red});
Refl_red = cell2mat({results(:).Refl_red});
Abs_red = cell2mat({results(:).Abs_red});
Trans_red = cell2mat({results(:).Trans_red});

r_blue = cell2mat({results(:).r_blue});
a_blue = cell2mat({results(:).a_blue});
Refl_blue = cell2mat({results(:).Refl_blue});
Abs_blue = cell2mat({results(:).Abs_blue});
Trans_blue = cell2mat({results(:).Trans_blue});

% p = plot(Ns, Refl);
% set(p, 'XDataSource', num2str(Refl,'%.7f'));
% refresh

% Chla ~ red
figure;
plot(Chlas, r_red);
xlabel('Chla'); ylabel('r-red');
title('r-red as function of Chla');

figure;
plot(Chlas, a_red);
xlabel('Chla'); ylabel('a-red');
title('a-red as function of Chla');

figure;
plot(Chlas, Refl_red);
xlabel('Chla'); ylabel('Refl-red');
title('Refl-red as function of Chla');

figure;
plot(Chlas, Abs_red);
xlabel('Chla'); ylabel('Abs-red');
title('Abs-red as function of Chla');

figure;
plot(Chlas, Trans_red);
xlabel('Chla'); ylabel('Trans-red');
title('Trans-red as function of Chla');

% Chla ~ blue
figure;
plot(Chlas, r_blue);
xlabel('Chla'); ylabel('r-blue');
title('r-blue as function of Chla');

figure;
plot(Chlas, a_blue);
xlabel('Chla'); ylabel('a-blue');
title('a-blue as function of Chla');

figure;
plot(Chlas, Refl_blue);
xlabel('Chla'); ylabel('Refl-blue');
title('Refl-blue as function of Chla');

figure;
plot(Chlas, Abs_blue);
xlabel('Chla'); ylabel('Abs-blue');
title('Abs-blue as function of Chla');

figure;
plot(Chlas, Trans_blue);
xlabel('Chla'); ylabel('Trans-blue');
title('Trans-blue as function of Chla');
