function [ pi_k_Aj ] = build_eta( N, r, a )
t = (1-r)*(1-a);
% define probabilities voctor: transient states to absorbing states
pi_k_Aj = zeros(2*N-1,N+2);
% probability to exit the left PBR (absorbe in state A0)
pi_k_Aj(1,1) = r;
pi_k_Aj(N+1,1) = t;
for k = 1:2*N-1 % possible states
    for j = 2:N+1 % "middle" absorbing states - prob to absorbed in cell i
        if (k+1 == j || k+1 == N+j)
            pi_k_Aj(k,j) = (1-r)*a;
        end
    end
end
% probability to exit the right PBR (absorbe in state An+2)
pi_k_Aj(N,N+2) = t;


end

