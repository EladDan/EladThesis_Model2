clear;

showResults = 1;

N_candidates = 5;
r_candidates = 0:0.05:1;
a_candidates = 0:0.05:1;

idx = 1;                          % # of row
r_idx = 1;
a_idx = 1;
n_idx = 1;

Results = zeros(size(a_candidates,2)*size(r_candidates,2)*size(N_candidates,2),6);
Refl = zeros(size(r_candidates,2), size(a_candidates,2), size(N_candidates,2));
Abso = zeros(size(r_candidates,2), size(a_candidates,2), size(N_candidates,2));
Trans = zeros(size(r_candidates,2), size(a_candidates,2), size(N_candidates,2));

for N = N_candidates
    for r = r_candidates
        for a = r_candidates
            t = (1-r)*(1-a);
            [~, ~, Transition_mat] = AbsorptionProbs(N, r, a);
            
            I = eye(2*N-1);                          % Identity matrix (Partial down-right of Transition_mat)
            Part_trans_mat = Transition_mat(1:2*N-1,1:2*N-1);    % Partial up-left of Transition_mat
            eta = build_eta(N, r, a);
            
            % find the steady-state probabilities to move from state k to state l=Aj
            % A0 <=> reflected out
            SS_k_A0 = pinv(I-Part_trans_mat) * eta(:,1);               % (I-Part_trans_mat)\eta(:,1) when j=1 <=> A(0)
            SS_k_Amid = zeros(1,N-1);
            for j = 2:N+1
                temp = pinv(I-Part_trans_mat) * eta(:,j);              % (I-Part_trans_mat)\eta(:,j) when j <=> A(j-1)
                SS_k_Amid(j-1) = temp(1);
            end
            % AN+1 <=> transmitted out
            SS_k_Alast = pinv(I-Part_trans_mat)* eta(:,N+2);          % (I-Part_trans_mat)\eta(:,N+2) when j=N+2 <=> A(N+1)
            
            
            % save red results
            Results(idx,1) = N;
            Results(idx,2) = r;
            Results(idx,3) = a;
            Results(idx,4) = SS_k_A0(1);     % total reflected light/incident light
            Results(idx,5) = sum(SS_k_Amid); % total absorbed light/incident light
            Results(idx,6) = SS_k_Alast(1);  % total transmitted light/incident light
            idx = idx + 1;
            
            Refl(r_idx, a_idx, n_idx) = SS_k_A0(1);
            Abso(r_idx, a_idx, n_idx) = sum(SS_k_Amid);
            Trans(r_idx, a_idx, n_idx) = SS_k_Alast(1);
            
            a_idx = a_idx + 1;
        end % end of a loop
        r_idx = r_idx + 1;
        a_idx = 1;
        
    end % end of r loop
    
    n_idx = n_idx + 1;
    r_idx = 1;
    a_idx = 1;
end % end of N loop

% plot results for Refl, Abso, and Trans
[A,R] = meshgrid(0:0.05:1,0:0.05:1); % X - A, Y - R

if (showResults == 1)
    % create X and Y values
    
    for n_idx = 1:size(N_candidates,2)
        % Refl vs. r,a graph
        %         figure('Position', [300, 600, 1200,300])
        figure
        subplot(1,2,1)
        surf(R,A,Refl(:,:,n_idx))
        %         view(3)
        % colorbar
        xlabel('r'); ylabel('a');zlabel('Total Reflection');
        %         title(sprintf('Refl vs. r,a - N = %.0f',N_candidates(n_idx)));
        set(gca,'FontWeight','bold')
        set(gca,'fontsize',16);
        ticks = [0:0.2:1];
        set(gca,'XTick',ticks,'YTick',ticks,'ZTick',ticks);
        
        % Trans vs. r,a graph
        subplot(1,2,2)
        surf(R,A,Trans(:,:,n_idx))
        %         colorbar
        xlabel('r'); ylabel('a');zlabel('Total Transmission');
        %         title(sprintf('Trans vs. r,a - N = %.0f',N_candidates(n_idx)));
        set(gca,'FontWeight','bold')
        set(gca,'fontsize',16);
        set(gca,'XTick',ticks,'YTick',ticks,'ZTick',ticks);
        
        
        %         waitforbuttonpress;
    end % for n_idx loop
end

% create derivatives for Refl

% step = 1;
% d_refl = zeros(size(Refl,1)*size(Refl,2), size(N_candidates,2)-1);
% for i = 1:size(Refl,1)        % scan all r's
%     for j = 1:size(Refl,2)    % scan all a's
%         N_refl = Refl(i,j,:); % take only the Refl values of specific r,a for all N_candidates
%         for n = 2:length(N_refl) % scan Refl vector for all N's, and calculate derivative dRefl/dN
%             d_refl(step,1) = r_candidates(i);
%             d_refl(step,2) = a_candidates(j);
%             d_refl(step,2+n-1) = (N_refl(n)-N_refl(n-1))/(N_candidates(n)-N_candidates(n-1));
%         end
%         step = step + 1;
%     end
% end

% plot results for dRefl
%
% for n_idx = 1:size(N_candidates,2)-1
%     % d_refl vs. r,a graph
%     figure
%     surf(R,A,Refl(:,:,n_idx))
%     view(3)
%     colorbar
%     xlabel('r'); ylabel('a');zlabel('derivRefl');
%     title(sprintf('Refl vs. r,a - N = %.0f,%.0f',[N_candidates(n_idx+1),N_candidates(n_idx)]));
%
%     %     % Abso vs. r,a graph
%     %     figure
%     %     surf(R,A,Abso(:,:,n_idx))
%     %     view(3)
%     %     colorbar
%     %     xlabel('r'); ylabel('a');zlabel('Abso');
%     %     title(sprintf('Abso vs. r,a - N = %.0f',N_candidates(n_idx)));
%     %
%     %     % Trans vs. r,a graph
%     %     figure
%     %     surf(R,A,Trans(:,:,n_idx))
%     %     view(3)
%     %     colorbar
%     %     xlabel('r'); ylabel('a');zlabel('Trans');
%     %     title(sprintf('Trans vs. r,a - N = %.0f',N_candidates(n_idx)));
% end % for n_idx loop

