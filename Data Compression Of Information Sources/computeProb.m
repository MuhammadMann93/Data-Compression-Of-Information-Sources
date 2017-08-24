function [probVector, keySet] = computeProb(runLengthEncodedStr, probOfZero, max_run_length)
% This function takes as input the string returned by run-length encoder
% and calculates probabilities for each symbol, which will then be used by
% HuffmanCompression. It also generates KeySet for Huffman
probVector = [];
keySet = [];

for num = 1 : length(runLengthEncodedStr)
    
    % check if current number is in keySet
    numToAdd = true;
    for k = 1 : length(keySet)
        if (keySet(k) ~= runLengthEncodedStr(num) || length(keySet) == 0)
            numToAdd = true;
        else
            % number exists, so break out of the loop
            numToAdd = false;
            break;
        end
    end
    
    if (numToAdd)
        % Only add in keyset and compute prob if the number is not in
        % keyset
        keySet = [keySet, runLengthEncodedStr(num)];
        
        if (runLengthEncodedStr(num) == max_run_length)
            % no ones here
            numOfZeros = runLengthEncodedStr(num);
            prob = probOfZero^numOfZeros;
            probVector = [probVector, prob];
        else
            % get number of zeros for each char
            numOfZeros = runLengthEncodedStr(num);
            % Here we assume that the probability to get 0 is 0.95
            prob = probOfZero^numOfZeros*(1 - probOfZero);
            probVector = [probVector, prob];
        end
    end
end
end