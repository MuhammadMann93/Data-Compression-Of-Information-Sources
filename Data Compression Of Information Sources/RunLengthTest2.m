function RunLengthTest2
% run-length encoding
% Note: max_run_length should be less than or equal to the size of input
% data
max_run_length = [3, 4, 6, 7, 9, 13, 15, 20, 25, 32];
probOfZeroes = 0.9;
iterationsPerMRL = 10;

%Variables for EofL testing
inputSize=[];
RLcompSize=[];
    HuffmanEL = 0;
    RLcompressionRatio = 0;
HuffmanCompSize=[];

% following variables will store data for plotting
HuffmanELToPlot = [];
RL_EToPlot = [];
RLcompressionRatioToPlot = [];
HuffmanCompressionRatioToPlot = [];

for mrl_idx = 1 : length(max_run_length)
    % iterations for each test
    
    % variables for each iteration
    RL_E = 0;
    HuffmanCompressionRatio = 0;
    
    for j = 1 : iterationsPerMRL
        inputData = rand(1,100) > probOfZeroes;
        encodedRes = Run_Length_Encoder(inputData, max_run_length(mrl_idx));%('000000101010101011010111001')
        
        % calculate prob for Huffman
        [p, keySet] = computeProb(encodedRes, probOfZeroes, max_run_length(mrl_idx));
        
        [p, idx] = sort(p,'descend');
        sortedKeySet = [];
        % sort keySet vector according to sorted probabilities index
        for i = 1 : length(keySet)
            % add keySet value at idx(i) to sortedKeySet
            sortedKeySet = [sortedKeySet, keySet(idx(i))];
        end
        
        % Huffman encoding
        [HuffmanEncoded, valueSet, l] = encoder(encodedRes, p, sortedKeySet);
        % Huffman decoding
        %HuffmanDecoded = decoder(HuffmanEncoded, sortedKeySet, valueSet, l);
        % Run-length decoding
        %decodedRes = Run_Length_Decoder(HuffmanDecoded, max_run_length);
        
        %Expected Length Testing
        B = dec2bin(encodedRes);
        
        [m,n] = size(B); % n will be the length of code words used for Run Length compression
        inputSize=[inputSize,length(inputData)];
        RLcompSize=[RLcompSize,m*n];
        % percentage of compression achieved through Run Length
        RLcompressionRatio = RLcompressionRatio +((m*n)/length(inputData));
        
        HuffmanCompSize = [HuffmanCompSize,length(HuffmanEncoded)];
        % percentage of compression achieved through Huffman
        HuffmanCompressionRatio = HuffmanCompressionRatio +(length(HuffmanEncoded))/(length(inputData));
        
        
        EofL = 0;
        %E(l) calculation for Run Length
        for numOfZeroes=0:max_run_length(mrl_idx)
            
            if(numOfZeroes~=max_run_length(mrl_idx))
                EofL =  EofL+((n/(numOfZeroes+1))*(probOfZeroes^numOfZeroes)*(1-probOfZeroes));
            end
            
            if numOfZeroes==max_run_length(mrl_idx)
                EofL =  EofL+((n/(numOfZeroes))*(probOfZeroes^numOfZeroes));
            end
        end
        
        RL_E = RL_E + EofL;
        
        %probability calculator for all huffman symbols that will be used to
        %compute E(l)
        Huffman_probs=[];
        
        for numOfZeroes=0:(max_run_length(mrl_idx))
            
            if(numOfZeroes~= max_run_length(mrl_idx))
                Huffman_probs = [Huffman_probs,(probOfZeroes^numOfZeroes)*(1-probOfZeroes)];
            end
            
            if(numOfZeroes==max_run_length(mrl_idx))
                Huffman_probs = [Huffman_probs,(probOfZeroes^numOfZeroes)];
            end
        end
        
        [p2,idx] =sort(Huffman_probs,'descend');
        
        RL_lengths = [];
        
        %all possible RL lengths stored in RL_lengths
        for numOfZeroes=0:max_run_length(mrl_idx)
            
            if(numOfZeroes~=max_run_length(mrl_idx));
                RL_lengths = [RL_lengths,numOfZeroes+1];
            end
            if(numOfZeroes==max_run_length(mrl_idx))
                RL_lengths = [RL_lengths,numOfZeroes];
            end
        end
        
        sortedRL_lengths = [];
        % sort sort RL_lengths with from highest probability to lowest
        for i = 1 : length(Huffman_probs)
            % add keySet value at idx(i) to sortedKeySet
            sortedRL_lengths = [sortedRL_lengths, RL_lengths(idx(i))];
        end
        %generate codebook for all RL symbols to compute its efficiency
        [l2,CB2] = Huffman(p2);
        
        HuffmanEofL=0; 
        %E(l) calculation for Huffman
        for i=1:(length(l2))
            
            HuffmanEofL =  HuffmanEofL+(((l2(i))/(sortedRL_lengths(i)))*(p2(i)));
            
        end
        
        HuffmanEL = HuffmanEL + HuffmanEofL;
    end
    % average out all variables
    RLcompressionRatio = RLcompressionRatio/iterationsPerMRL;
    HuffmanCompressionRatio = HuffmanCompressionRatio/iterationsPerMRL;
    HuffmanEL = HuffmanEL/iterationsPerMRL;
    RL_E = RL_E/iterationsPerMRL;
    
    % Now store the averaged out values for plots
    HuffmanELToPlot = [HuffmanELToPlot HuffmanEL];
    RL_EToPlot = [RL_EToPlot RL_E];
    RLcompressionRatioToPlot = [RLcompressionRatioToPlot RLcompressionRatio];
    HuffmanCompressionRatioToPlot = [HuffmanCompressionRatioToPlot HuffmanCompressionRatio];
    
end
% Plot for E-L comparison
figure
plot(max_run_length, RL_EToPlot);
hold on
plot(max_run_length, HuffmanELToPlot);
hold on
plot([0,max_run_length(mrl_idx)],[0.286,0.286]);
hold on
plot([0,max_run_length(mrl_idx)],[0.286+1,0.286+1]);
grid on
legend('Run-Length', 'Run-Length + Huffman','H(x)');
xlabel('max run-length size');
ylabel('E(L)');
title(strcat('E(L) comparison between Run-Length and Run-Length+Huffman, probOfZeroes = ',num2str(probOfZeroes)));

% Plot for E-L comparison
figure
plot(max_run_length, RLcompressionRatioToPlot);
hold on
plot(max_run_length, HuffmanCompressionRatioToPlot);
grid on
legend('Run-Length', 'Run-Length + Huffman');
xlabel('max run-length size');
ylabel('Compression ratio');
title(strcat('Compression ratio comparison between Run-Length and Run-Length+Huffman, probOfZeroes = ',num2str(probOfZeroes)));
% hist(HuffmanCompSize/1000, 20);
% grid on
% title('Huffman compression efficiency');
end