function [ corrupted_row, sum_row ] = validate_transition_mat( Transition_mat,verbose )
% checks if the sum of each row of the matrix equals 1
% input: - Transition_mat: transition matrix
%        - verbose: if set to 0 - do not print in case all good
% output: - corrupted_row: returns 0 if the transition matrix is valid
%                          otherwise, returns the number of the invalid row

corrupted_row = 0;
sum_row = 1;
% check transition matrix routine - rows must be equal to 1
for k = 1:size(Transition_mat,1)
    if round(sum(Transition_mat(k,:)),10) ~= 1
        corrupted_row = k;
        sum_row = sum(Transition_mat(k,:));
        fprintf('ERROR, transition matrix row %.0f equals to %.10f\n',corrupted_row,sum_row);
        break
    else
        if verbose
            fprintf('OK, transition matrix row number %.0f\n',k);
        end
    end
end

% if (corrupted_row > 0)
%     fprintf('ERROR, transition matrix row %.0f equals to %.10f\n',corrupted_row,sum_row);
%     return
% end

end % end function

