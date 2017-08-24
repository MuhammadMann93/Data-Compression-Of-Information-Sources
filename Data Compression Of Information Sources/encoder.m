function [compr_strng, valueSet, l] = encoder(data, p , keySet)
% Encodes input data according to Huffman algorithm 
% and returns the compressed string and the efficiency of the 
% compressed string

%data = [1 1]; 
%p=[0.3 0.23 0.22 0.2 0.05];

[l, CB] = Huffman(p); 

new_entry = ''; 
CB_str=''; 
valueSet = {}; 

    % Extract codebook values with their respective length into
    % an array valueset, each entry in valueSet is in the same 
    % order to its corresponding symbol in array keySet 
    
    for c=1: length(p)
        for b=1: l(c) 
            CB_str = num2str(CB(c,b));  
            new_entry =  [new_entry, CB_str];
        end 
        valueSet = [valueSet; new_entry];
        new_entry = ''; 
    end
    
   % mapObj = containers.Map(keySet, valueSet); 
    
    % Loop over input data and generate the compr_string according to 
    % the encoded values genereated in valueSet whic corresponds to 
    % their symbol in keySet
    compr_strng = [];

    for i=1:length(data)
         for j=1:length(keySet)
             if data(i) == keySet(j)
                 compr_strng = [compr_strng, valueSet{j}]; 
             end
         end
    end 

end


        

     