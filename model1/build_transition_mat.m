function [ Transition_mat ] = build_transition_mat( N, r, a, p_encount)
% define probabilities matrix to move from any state to any state
% and check sum of each row equals to 1
% inputs:
%       - N: the natural number of layers (composed of cubic cells) inside the PBR, proportional to the
%            algae concentration
%       - r: elementary (on a cell basis) probability for a photon to reflect back
%       - a: elementary (on a cell basis) probability for a photon to absorbe in cell i
%       - p_encount: probabilty to encounter a layer
% output:
%       - Transition_mat

K = 3*N+1;
t = (1 - p_encount) + (1-r) * (1-a) * p_encount;
Transition_mat = zeros(K, K);

% define all moving forward beams

% define what happens to entering beam
% notation: Transition_mat(k,l) = Transition_mat(raw,col)
k=1;
Transition_mat(k,2*N) = r * p_encount; % it can reflect out of the PBR
Transition_mat(k,2*N+1) = (1-r) * a * p_encount; % it can be absorbed in cell 1
Transition_mat(k,2) = t; % it can pass cell 1

% define what can happen to beams that are moving forward, except
% for the entering and the beam moving forward to cell N
for k = 2:N-1
    Transition_mat(k,k+N-1) = r * p_encount; % it can reflect to the other direction i->i-1
    Transition_mat(k,k+2*N) = (1-r)*a* p_encount; % it can absorbed in cell i
    Transition_mat(k,k+1) = t; % it can pass to the next cell i->i+1
end

% what happens to beam that moves forward N-1->N
k=N;
Transition_mat(k,2*N-1) = r * p_encount;    % it can reflect to the other direction
Transition_mat(k,3*N) = (1-r)*a* p_encount; % it can be absorbed in cell N
Transition_mat(k,3*N+1) = t;                % it can exit the right side of the PBR

% define all moving backwards beams
% what happens to beam that moves backward to cell 1
k=N+1;
Transition_mat(k,2) = r * p_encount;          % it can reflect to the other direction
Transition_mat(k,2*N+1) = (1-r)*a* p_encount; % it can absorbed cell 1
Transition_mat(k,2*N) = t;                    % it can exit the left side of PBR

% define what can happen to beam moving backward, except of the beam moving
% to cell 1
for k = N+2:2*N-1
    Transition_mat(k,k-N+1) = r * p_encount;   % it can reflect to the other direction
    Transition_mat(k,k+N) = (1-r)*a*p_encount; % it can absorbed in the cell infront it (cell k-n)
    Transition_mat(k,k-1) = t;                 % it can pass to the next cell (i,i-1) -> (i-1,i-2)
end

% define absorbing states
for k = 2*N:3*N+1
    Transition_mat(k,k) = 1;                   % it is trapped
end

end

