function [ absorption_probs, SS_mat, Transition_mat ] = AbsorptionProbs( N, r, a )
% define probabilities matrix to move from any state to any state and then
% multiply by it self a lot
% inputs:
%       - N: the number of cells inside the PBR, proportinate to the
%            algae concentration
%       - r: probability for a photon to reflect back
%       - a: probability for a photon to absorbe in cell i
% output:
%       - absorption_probs: 2-dim matrix: row 1 holds i, row 2 holds p(i)

Transition_mat = build_Transition_mat( N, r, a);

SS_mat = Transition_mat^512;

% for k = 1:size(SS_mat,1)
%     if sum(SS_mat(k,:)) ~= 1
%         error('sum of row %.0f is equal to %.15f',[k,sum(SS_mat(k,:))]);
%     end
% end

absorption_probs(1,:) = 0:N+1;
% We'll see what is the probability for the entering beam to absorbe at
% states A_0 - A_N+1
absorption_probs(2,:) = SS_mat(1,2*N:3*N+1);

end % function

