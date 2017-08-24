function [l, CB] = combineProbabilities(p, CB_to_split, is_codebook_generated)

% Note: Always pass in CB_to_split as empty array [], during function call!
%       is_codebook_generated is also passed in as false

% n = length of probability vector (p)
n = length(p);
index = 0;

% When n = 2, the vector p has been sorted. Call
% generateCodebook to make CB.
if (n == 2)
    [l, CB] = generateCodebook(CB_to_split);
    % is_codebook_generated is set to true here to prevent subsequent
    % recursion when return is called.
    is_codebook_generated = true;
    return;
end

% if statement to prevent recursion after CB has been generated
if (~is_codebook_generated)
    q = [];
    % Loop over all probabilities
    for i = 1 : n
        if ((p(n-1) + p(n)) > p(i))
            % if current probability is smaller than the sum of last two
            % probabilities, we have found the index where we need to split
            index = i;
            
            % a = all probabilities from 1 to i - 1
            % b = probabilities to combine
            % c = remaining probabilities
            a = p(1 : i - 1);
            b = p(n - 1) + p(n);
            c = p(i : n - 2);
            
            % Make vector q from a, b and c. q is the new probability
            % vector
            q = [a, b, c];
            break
        end
    end
    
    % Prepare CB_to_split for recursion. This is actually the output of
    % our function, which is passed into generateCodebook()
    CB_to_split = [CB_to_split, index];
    
    % Recursive call. The outputs assigned here are just to make matlab
    % happy and are not the final outputs
    [l, CB] = combineProbabilities(q, CB_to_split, is_codebook_generated);
end

end