function [ Refl, Abso, Tran ] = get_analytical_results2( Params, Nreal )
% Anaylical solution:
% 1. build first row of the (I-P)^-1 mat
% 2. build eta matrix
% multiply them

N = Params.N;
r = Params.r_red;
a = Params.a_red;
t = (1-r)*(1-a);
if exist('Nreal','var') && ~isempty(Nreal)
    p_encount = Nreal/N;
else
    p_encount = 1;
end

[ Transition_mat ] = build_transition_mat( N, r, a, p_encount);

I = eye(2*N-1);                       % Identity matrix
Part_trans_mat = Transition_mat(1:2*N-1,1:2*N-1); % partial transition matrix (only for transient states)
temp = inv(I-Part_trans_mat);
x = temp(1,:);

% here x = inv(I-Part_trans_mat)[1];


% define probabilities vectors: transient states to absorbing states
% (eta used to be pi_k_Aj)
eta = zeros(2*N-1,N+2);
t = (1 - p_encount) + (1-r) * (1-a) * p_encount;
% probability to exit the left PBR (absorbe in state A0)
eta(1,1) = p_encount * r;
eta(N+1,1) = t;
for k = 1:2*N-1 % possible states
    for j = 2:N+1 % "middle" absorbing states - prob to absorbed in cell i
        if (k+1 == j || k+1 == N+j)
            eta(k,j) = p_encount*(1-r)*a;
        end
    end
end
% probability to exit the right PBR (absorbe in state An+2)
eta(N,N+2) = t;


% find the "final" probability to move from state 1 to state Aj (our solution)
SS_k_A0_1 = x * eta(:,1);

SS_k_Alast_1 = x * eta(:,N+2);

% take the first row (k=1, initial beam) from the steady-state mat (pi)
Refl = SS_k_A0_1;
Tran = SS_k_Alast_1;
Abso = 1-Refl-Tran;



end

