function IntermediateSymbol = Run_Length_Encoder(inputData, maxLength)
% This encoder looks for a series of 0s until it hits a 1. The number of 0s
% counted till the point of getting a 1 is the run count for that
% corresponding run. So, 0001 compresses to 3. Also note that inputData is
% string of binary, entered via quotes. Hitting a single 1 gives the
% compression as 0.

compressedOutput = [];
% First add a 1 at the end of inputData to ensure that there's a 1 at the
% end of the file. This is to ensure that we do not encounter a run such as
% 0000, at the end of the file
inputData = [inputData, 1];

% The process is repeated until input data is empty
while (~isempty(inputData))
    runCount = 0;
    for bit = 1 : length(inputData)
        if (inputData(bit) == 0)
            % if the current bit is 0, increment the run
            runCount = runCount + 1;
        else
            % as soon as we hit a 1, add the current run to compressedOutput
            % Remove the run from inputData and break out of the for loop
            compressedOutput = [compressedOutput, runCount];
            % The +2 here ensures that we take inputData after the runCount
            % and the 1 ending the run, for the next iteration
            inputData = inputData((runCount + 2) : end);
            break;
        end
        
        if (runCount == maxLength)
            % break out of loop if runCount equals maxLength
            compressedOutput = [compressedOutput, runCount];
            % we do +1 here since there's no 1 ending the run here
            inputData = inputData((runCount + 1) : end);
            break;
        end
        
    end
end

IntermediateSymbol = compressedOutput;

end