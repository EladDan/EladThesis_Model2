% 1. calculate the number of layers from concentration.
% 2. build transition matrix (and SS matrix).
% 3. print results
% 4. calculate analytical solution:
% 4.a. build Identity matrix, partial Transition matrix and eta () matrix

clear;

% INPUT
Chla = 0.010402;                   % Chla concentration in mg/cm^3
Chlb_ = 0.35;                   % weight ratio Chlb/Chla
Car_ = 0.56;                    % weight ratio Car/Chla

% [N, r_red, r_blue, a_red, a_blue] = getNumberLayers(Chla, Chlb_, Car_);
% r = r_red;
% a = a_red;

N = 5;
r = 0.2;
a = 0.43;

[ AP, SS_mat, Transition_mat ] = AbsorptionProbs(N, r, a);

% plot
% AP = Abs Probs vector (size N+2 x 1) is the first row of the steady-state
% matrix (transition matrix raised to a high power)
% col_names = [string('refl'), string('Abs1'),string('Abs2'),string('Abs3'),string('Abs4'),string('Abs5'),string('Abs6'),string('Trans')]

% bar(AP(1,:),AP(2,:))
% axis([-0.5 N+1.5 0 1])
% xlabel('Absorption states')
% ylabel('Probabilities')
% set(gca,'FontWeight','bold')
% title(sprintf('Absorbtion probabilities (N: %.f, r: %.2f, a: %.2f)',N,r,a));

figure(1)
axis([-0.5 N+1.5 0 1])
xlabel('A_i states')
ylabel('Probabilities')
set(gca,'FontWeight','bold')
% title(sprintf('Absorbtion probabilities (N: %.f, r: %.2f, a: %.2f)',N,r,a));
hold on
for i = 1:length(AP(2,:))
    h=bar(AP(1,i),AP(2,i));
    if AP(1,i) == 0
        set(h,'FaceColor','b');
    elseif AP(1,i) >= 1 && AP(1,i) <= N
        set(h,'FaceColor','k');
    else
        set(h,'FaceColor','b');
    end
    ticks{i} = strcat('A_',num2str(i-1));
end

set(gca,'XTickLabel',ticks);
set(gca,'FontWeight','bold')
set(gca,'fontsize',14);
hold off

% % final probs:
% AP(2,1) % refl
% sum(AP(2,2:N+1)) % abso
% AP(2,N+2) % trans

% analytical solution
I = eye(2*N-1);                       % Identity matrix
Part_trans_mat = Transition_mat(1:2*N-1,1:2*N-1); % partial transition matrix (only for transient states)
temp = inv(I-Part_trans_mat);
temp(1,:)


% define probabilities vectors: transient states to absorbing states
% (eta used to be pi_k_Aj)
t = (1-r)*(1-a);
eta = zeros(2*N-1,N+2);
% probability to exit the left PBR (absorbe in state A0)
eta(1,1) = r;
eta(N+1,1) = t;
for k = 1:2*N-1 % possible states
    for j = 2:N+1 % "middle" absorbing states - prob to absorbed in cell i
        if (k+1 == j || k+1 == N+j)
            eta(k,j) = (1-r)*a;
        end
    end
end
% probability to exit the right PBR (absorbe in state An+2)
eta(N,N+2) = t;


% find the "final" probability to move from state 1 to state Aj (our solution)
SS_k_A0 = inv(I-Part_trans_mat) * eta(:,1);
SS_k_Amid = zeros(1,N);
for j = 2:N+1
    temp = inv(I-Part_trans_mat) * eta(:,j);
    SS_k_Amid(j-1) = temp(1);
end
SS_k_Alast = inv(I-Part_trans_mat)* eta(:,N+2);

% take the first row (k=1, initial beam) from the steady-state mat (pi)
Refl = SS_k_A0(1);
Abso = sum(SS_k_Amid);
Trans = SS_k_Alast(1);

disp(Refl); % total reflected light/incident light
disp(Abso); % total absorbed light/incident light
disp(Trans); % total transmitted light/incident light




