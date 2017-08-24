function [l, CB] = generateCodebook(CB_to_split_indices)

% initialize
CB = [0; 1];
l = [1, 1];

% Loop backwards in CB_to_split_indices array.
% This is done because the last index of this array 
% has only 2 elements of probability and hence corresponds
% with the initial CB of [0; 1]
for i = length(CB_to_split_indices) : -1 : 1
    
    % Current index to split
    index_to_split = CB_to_split_indices(i);
    
    % temp variable to update codebook after split
    l_of_splitted_cw = l(index_to_split); 
    
    % split and make new l. Duplicate l at index to split and 
    % add one to increase l for the indices being spit.
    l = [l(1 : index_to_split - 1);
        l(index_to_split + 1 : end);
        l(index_to_split) + 1;
        l(index_to_split) + 1];
    
    % Create a column of zeros. To be appended in CB
    zero_column = zeros(length(CB), 1);
    
    % Append CB with zero column
    CB = [CB, zero_column];
    
    % Create a copy of the row to split from CB
    splitted_row_copy = CB(index_to_split, :);
    
    % Change the digit of splitted_row_copy to 1, the bit to 
    % change specified by L vector. This is the new row to insert to CB.
    splitted_row_copy(l_of_splitted_cw + 1) = 1;
    
    % Insert splitted_row_copy in CB. CB now contains all rows from start
    % to index_to_split - 1, and then the rows after index_to_split. 
    % The row at index_to_split is then inserted (making it the 2nd last
    % row), followed by splitted_row_copy.
    CB = [CB(1 : index_to_split - 1, :);
        CB(index_to_split + 1 : end, :)
        CB(index_to_split, :);
        splitted_row_copy];
    
end

end