clc
clear all

source_symbols = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'];
p = [0.274, 0.171, 0.149, 0.130, 0.092, 0.057, 0.052, 0.042, 0.031, 0.002];
mixed_data= ['h','i','d','e'];
% Perform encoding of the data above
[compr_strng1, valueSet, l] = encoderV3(mixed_data, p, source_symbols);

% Print out the codebook
fprintf('The codebook for above source_symbols: \n');
for i = 1 : size(valueSet)
    fprintf('%s = %s \n', source_symbols(i), valueSet{i});
end
efficiency=0;
%source efficiency
for i=1:length(l)
   efficiency= p(i)*l(i)+efficiency; 
end
%histogram generation
% Perform encoding and decoding 1000 times
count=0; 
for n = 1:1000
%     % input vector size is 50, consisting of digits 0, 1 and 2.
     input= randsample(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'],50,true);
%     % perform encoding of input and generate a compressed string
   [compr_strng2, valueSet2, l2] = encoderV3(input, p, source_symbols);
%     % Store the length of each compression in the vector count.
%     % This is used to plot the histogram
        count = [count, length(compr_strng2)];
%     % Decompress the compressed string
%    output = decoder(compr_strng);
%     % Perform equality check
% %     if (~isequal(input, output))
% %         fprintf('Input vector is not equal to the output vector of decoder!\n');
 %    end
 end
% 

%Plot histogram of vector count
hist(count/50, 20);
grid on
title('Huffmann algorithm');
ylabel('Frequency');
xlabel('Length of encoded string');

fprintf('\ndata to encode = %s \n', mixed_data);
% Print out the encoded string for the data
fprintf('\nThe encoded string for data above: \n');
fprintf('%s = %s \n', mixed_data, compr_strng1);

% Decode data and print out the result
decoded_data = decoderV3(compr_strng1, source_symbols, valueSet, l);
fprintf('\nThe decoded data = %s \n', decoded_data);