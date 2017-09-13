function [ matrix ] = struct2matrix( struct )
struct = struct2cell(struct);
matrix = cell2mat(struct);
matrix = squeeze(matrix);
matrix = matrix';
end

