% Clear and close everything first
clear all
clc
tic
count = [];
% Perform encoding and decoding 1000 times
% for n = 1:1000
    % input vector size is 50, consisting of digits 0, 1 and 2.
    input = randsrc(1,10000,[1,2,3; 0.5,0.3,0.2]);
    % perform encoding of input and generate a compressed string
    compr_strng = encoder(input);
    % Store the length of each compression in the vector count.
    % This is used to plot the histogram
%     count = [count, length(compr_strng)];
    % Decompress the compressed string
   output = decoder(compr_strng);
    % Perform equality check
%     if (~isequal(input, output))
%         fprintf('Input vector is not equal to the output vector of decoder!\n');
%     end
% end

% TODO: Should this be approxiamately E(l)? Can we somehow plot it on histogram?
efficiency = 0.5*1 + 0.3 *2+ 0.2*2;
% Plot histogram of vector count
% hist(count/100, 20);
% grid on
% title('Huffmann algorithm');
% ylabel('Frequency');
% xlabel('Length of encoded string');
toc