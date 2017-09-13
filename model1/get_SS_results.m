function [ Refl, Abso, Tran ] = get_SS_results( Transition_mat, M )

N = (size(Transition_mat,1)-1)/3;

if exist('M','var')
    power = 2^M;
else
    power = 2^10;
end

SS_mat = Transition_mat^power;

% We'll see what is the probability for the entering beam to absorbe at
% states A_0 - A_N+1
final_probs = SS_mat(1,2*N:3*N+1);

Refl  = final_probs(1); 
Abso  = sum(final_probs(2:N+1));
Tran  = final_probs(N+2);

end