function [RLcompressionRatioToPlot, HuffmanCompressionRatioToPlot] = RunLengthPerformanceTest(probOfZeroes)
% run-length encoding
% Note: max_run_length should be less than or equal to the size of input
% data
max_run_length =[3, 7, 15, 31,61];
probOfZeroes = 0.95;
iterationsPerMRL = 10;

%Variables for EofL testing
inputSize=[];
RLcompSize=[];
HuffmanCompSize=[];

% following variables will store data for plotting
HuffmanELToPlot = [];
RL_EToPlot = [];
RLcompressionRatioToPlot = [];
HuffmanCompressionRatioToPlot = [];
decodedResultToPlot = [];
for mrl_idx = 1 : length(max_run_length)
    % iterations for each test
    
    % variables for each iteration
    RL_E = 0;
    HuffmanEL = 0;
    RLcompressionRatio = 0;
    HuffmanCompressionRatio = 0;
    
    for j = 1 : iterationsPerMRL
        
        decodedResult_Comp=0;
        inputData = rand(1,10^4) > probOfZeroes;
        encodedRes = Run_Length_Encoder(inputData, max_run_length(mrl_idx));%('000000101010101011010111001')
        decodedRes = Run_Length_Decoder(encodedRes,max_run_length(mrl_idx));
        
        if decodedRes == inputData
           decodedResult_Comp=1;
        end
        
        decodedResultToPlot = [decodedResultToPlot,decodedResult_Comp];
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
        
        % TODO: n needs to vary here. Need to check notes from Shorouq's
        % notebook to see what n should be here
        [m,n] = size(B);
        inputSize=[inputSize,length(inputData)];
        RLcompSize=[RLcompSize,m*n];
        % percentage of compression achieved through Run Length
        RLcompressionRatio = RLcompressionRatio +((m*n)/length(inputData));
        
        HuffmanCompSize = [HuffmanCompSize,length(HuffmanEncoded)];
        % percentage of compression achieved through Huffman
        HuffmanCompressionRatio = HuffmanCompressionRatio +(length(HuffmanEncoded)/length(inputData));
        
        
        avgRunRL = 0;
        %E(l) calculation for Run Length
        for i=0:max_run_length(mrl_idx)
            
            if(i~=max_run_length(mrl_idx))
                avgRunRL =  avgRunRL+((i+1)*(probOfZeroes^i)*(1-probOfZeroes));
            end
            
            if i==max_run_length(mrl_idx)
                avgRunRL =  avgRunRL+(i*(probOfZeroes^i));
            end
        end
        % EofL here is essentially length the avg of each run (prob of each
        % run*run-length)
        RL_E = RL_E + n/avgRunRL;
        
        %probability calculator for all huffman symbols that will be used to
        %compute E(l)
        Huffman_probs=[];
        
        for i=0:(max_run_length(mrl_idx))
            
            if(i~= max_run_length(mrl_idx))
                Huffman_probs = [Huffman_probs,(probOfZeroes^i)*(1-probOfZeroes)];
            end
            
            if(i==max_run_length(mrl_idx))
                Huffman_probs = [Huffman_probs,(probOfZeroes^i)];
            end
        end
        
        [p2,idx] =sort(Huffman_probs,'descend');
        
        RL_lengths = [];
        
        %all possible RL lengths stored in RL_lengths
        for i=0:max_run_length(mrl_idx)
            
            if(i~=max_run_length(mrl_idx));
                RL_lengths = [RL_lengths,i+1];
            end
            if(i==max_run_length(mrl_idx))
                RL_lengths = [RL_lengths,i];
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
        avgOfRuns = 0;
        %E(l) calculation for Huffman
        for i=1:(max_run_length((mrl_idx))+1)
            % avg of compression after huffman
            avgOfRuns = avgOfRuns + l2(i)*p2(i);
            
        end
        for i=1:(max_run_length((mrl_idx))+1)
            % each run in sortedRL_lengths is compressed by avgOfRuns
            HuffmanEofL =  avgOfRuns/sortedRL_lengths(i);
        end
        
        HuffmanEL = HuffmanEL + avgOfRuns/avgRunRL;
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

%Plot for RL-E comparison
figure
stem(decodedResultToPlot);
% hold on
% stem(max_run_length, HuffmanELToPlot);
grid on
legend('comparison');
xlabel('iterations');
axis([0 50 0 1.4])
title(strcat('Decompression Result Comparison with input file, file Size=10000, p0=0.95'));


% Plot for E-L comparison
% figure
% stem(max_run_length, RLcompressionRatioToPlot);
% hold on
% stem(max_run_length, HuffmanCompressionRatioToPlot);
% grid on
% legend('Run-Length', 'Run-Length + Huffman');
% xlabel('max run-length size');
% ylabel('Compression ratio');
% title(strcat('Compression ratio comparison, file size = 10000, p0 = ',num2str(probOfZeroes)));
% hist(HuffmanCompSize/1000, 20);
% grid on
% title('Huffman compression efficiency');
end