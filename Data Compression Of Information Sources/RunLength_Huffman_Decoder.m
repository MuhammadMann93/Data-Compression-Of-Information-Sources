function [Decodedfile] = RunLength_Huffman_Decoder(Compr_Strng,l,CB)
%empty array for the Decompressed file
Decodedfile = [];
%matrix of runlength bit words from most probable to least probable, to
%match the order in which huffman codewords get assigned in the CB matrix
%since all rows in a matrix must have the same dimension so extra 0's 
%were added and a vector created to store the length of each runlength bit word 
RunLength = [0 0 0 0 0 0 0;1 0 0 0 0 0 0;0 1 0 0 0 0 0;0 0 1 0 0 0 0;0 0 0 1 0 0 0;0 0 0 0 1 0 0;0 0 0 0 0 1 0;0 0 0 0 0 0 1];
rowDim = [7 1 2 3 4 5 6 7];
%loop variable i
i=1;
%length of the compressed string will change as decompression takes place
%therefore the condition for termination of while loop is when the
%compr_strng is empty
while (~isempty(Compr_Strng))
%during each iteration the loop compares the compressed string code words with rows of CB matrix
%and whenever a match takes place it stores the
%corresponding runlength bits in the array Decodedfile & repeats the same
%process for the next code word in the compr_strng array until all the code
%words are decompressed 
if Compr_Strng(1:l(i)) == CB(i,1:l(i))    
Decodedfile = [Decodedfile,RunLength(i,1:rowDim(i))];
Compr_Strng = Compr_Strng(l(i)+1:end)
i=0;
end

i=i+1;
end    
    
end
    
    
