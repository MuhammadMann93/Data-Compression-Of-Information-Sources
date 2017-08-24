function HuffmanImgCompressin

clc

imgPath = 'C:\Users\Mohd\Desktop\imageTest\test4.jpg';
compImgPath = 'C:\Users\Mohd\Desktop\imageTest\compImg.mat';

img =imread(imgPath);


img = rgb2gray(imread(imgPath));

imgBin = imbinarize(img);

save('C:\Users\Mohd\Desktop\imageTest\binImage.mat', 'imgBin');
[rSize, cSize] = size(imgBin);

compSize = 0;
originalImgSize = rSize*cSize;

 for row = 1 : rSize
    for col = 1 : cSize
        imgBin(row, col) = ~imgBin(row, col);
    end
 end


 p1 = 0;
p0 = 0;
for row = 1 : rSize
    for col = 1 : cSize
        if (imgBin(row, col) == 1)
            p1 = p1 + 1;
        else
            p0 = p0 + 1;
        end
    end
end

p0 = p0/(rSize*cSize);
p1 = p1/(rSize*cSize);



%imgBin(126,1:453);

for i=1:rSize
runLengthEncoded = Run_Length_Encoder(imgBin(i,1:cSize), 31);

[p, keySet] = computeProb(runLengthEncoded, p0, 31);

[p, idx] = sort(p,'descend');

sortedKeySet =[];

for j=1:length(p)
    
    sortedKeySet = [sortedKeySet,keySet(idx(j))];
    
end
 
 if length(sortedKeySet)==1
       
 HuffmanEncoded = 0;
 valueSet = 0;
 l = 1;
 
toSave.(strcat('HuffmanEncoded', num2str(i)))=HuffmanEncoded;
 toSave.(strcat('sortedKeySet', num2str(i)))=sortedKeySet;
    toSave.(strcat('valueSet', num2str(i)))=valueSet;
     toSave.(strcat('l', num2str(i)))=l;

    if exist(compImgPath, 'file')==2
        save(compImgPath, 'toSave', '-append');
    else
        save(compImgPath, 'toSave');
    end

 else   
[HuffmanEncoded, valueSet, l] = encoder(runLengthEncoded, p , sortedKeySet);

compSize = compSize+length(HuffmanEncoded);

toSave.(strcat('HuffmanEncoded', num2str(i)))=HuffmanEncoded;
 toSave.(strcat('sortedKeySet', num2str(i)))=sortedKeySet;
    toSave.(strcat('valueSet', num2str(i)))=valueSet;
     toSave.(strcat('l', num2str(i)))=l;

    if exist(compImgPath, 'file')==2
        save(compImgPath, 'toSave', '-append');
    else
        save(compImgPath, 'toSave');
    end

    
 end   
end

compSize= compSize/(rSize*cSize) 

% for row=1:rSize
% RunLengthEncoded = [RunLengthEncoded, Run_Length_Encoder(imgBin(row), 31)];
% 
% end

compressedFile = load(compImgPath);
savedVar = compressedFile.('toSave');

decompressedImg = [];
for i = 1 : rSize
    HuffmanEncoded = savedVar.(strcat('HuffmanEncoded', num2str(i)));
    sortedKeySet = savedVar.(strcat('sortedKeySet', num2str(i)));
    valueSet = savedVar.(strcat('valueSet', num2str(i)));
    l = savedVar.(strcat('l', num2str(i)));
    
    if length(sortedKeySet)==1
       
    dataHAT (1:cSize)= valueSet;
        
    else
    dataHAT = decoder(HuffmanEncoded, sortedKeySet, valueSet, l);
    end
    decompressedRow=[];
    
    for j=1:length(dataHAT)
    
     RL = dataHAT(j);   
     for k=1:(RL+1)   
     
         if (k==RL) && not(RL==31)
              decompressedRow=[decompressedRow,0,1];  
              break
         elseif (k==RL) && (RL==31)
             decompressedRow=[decompressedRow,0]; 
             break
         elseif (RL==0)
             decompressedRow=[decompressedRow,1]; 
             break             
         else
           decompressedRow=[decompressedRow,0];   
             
        end
     end
    end   
 decompressedRow=decompressedRow(1:end-1); 
 
 if length(decompressedRow)<cSize
 
 diff = cSize - length(decompressedRow);
 
 for m=1:diff
 
 decompressedRow=[decompressedRow,0];    
     
 end
     
 end
 
 decompressedImg = [decompressedImg; decompressedRow];

 
end
%invert the image
for row = 1 : rSize
    for col = 1 : cSize
        decompressedImg(row,col) = ~decompressedImg(row,col); 
    end
end

%decompressedImg=255*uint8(decompressedImg);
imshow(decompressedImg);


end