function [Compr_Strng] = RunLength_Huffman_Encoder(Sourcedata)

%this function will use the same huffman compression functions that we have
%from Design Project1
 Compr_Strng = [];
%since the max run of bits to be compressed will have 7 bits, this gives
%us a maximum of 8 different possibilities for source probabilities
%the source probabilities are calculated and stored in this vector array
p = [0.05,0.95*0.05,0.95^2*0.05,0.95^3*0.05,0.95^4*0.05,0.95^5*0.05,0.95^6*0.05,0.95^7];
%our huffman function requires that probabilities are sorted in descended
%order
p=sort(p,'descend');
%the output of the huffman function will give us the codebook matrix 
%along with the length vector that has the size of each code word
[l,CB] = Huffman(p);
%i is the variable used for the condition of the while loop
 i=1;
 %since the compression is based on the run of 0's and the largest run that is
%compressed will have seven 0's therefore the while loop will iterate until
%it comes across a 1; the max run being seven 0's 
    while (~isempty(Sourcedata))
        
        if Sourcedata(i) == 1 
% as soon as there's a 1, the run of pixels/bits is comressed with the
% appropriate code word from the code book matrix   
           Compr_Strng = [Compr_Strng,CB(i+1,1:l(i+1))];
%the part of the source file that has been compressed is deleted from the
%array storing the values and the loop is reseat to repeat the process           
           Sourcedata = Sourcedata(i+1:end);
           i=0;
        end
        
        if i==7 && Sourcedata(i)==0
%if there's no 1 for a run of 7 consecutive bits, compression needs to
%be done with a seperate statement so that the loop can be reset if the
%entire source data file has not been compressed yet.           
          Compr_Strng = [Compr_Strng,CB(1,1)];
%the part of the source file that has been compressed is deleted from the
%array storing the values and the loop is reseat to repeat the process            
          Sourcedata = Sourcedata(i+1:end); 
          i=0;
       end
   %as soon as the entire source data file has been compressed, the while loop is
   %ended with a break statement        
        if length(Sourcedata) ==0
          
          break
       end
        
       i=i+1;
    end
    


end