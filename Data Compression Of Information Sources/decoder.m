function dataHAT = decoder(compr_strng, keySet, valueSet, l)
% Decodes the input compressed string according to the
% of the Huffman algorithm.

    dataHAT = []; 
   
    %data = [0 0 0]; 
    %[compr_strng, keySet,valueSet, l] = encoder(data);

    dataDim = length(compr_strng);
    % Loop over length of compr_strng, decrementing its size each time 
    % a code is matched to its correspondind symbol and extracted. 
    % Loops through each entry in valueSet and extracts first symbols 
    % in compr_strng of same size, then compares it to the code. If true 
    % a symbol is added to dataHAT and compr_strng is resized.
    while (dataDim ~= 0)
        for j=1: length(valueSet)
            for k=1: l(j)
                if length(compr_strng) < l(j)
                    break   
                else if length(valueSet{j}) == length(compr_strng (1: k)); 
                    if compr_strng (1: k) == valueSet{j}
                        dataHAT = [dataHAT, keySet(j)];
                        compr_strng = compr_strng(k+1: length(compr_strng));
                        dataDim = length(compr_strng); 
                    end
                end
            end
        end
    end
end