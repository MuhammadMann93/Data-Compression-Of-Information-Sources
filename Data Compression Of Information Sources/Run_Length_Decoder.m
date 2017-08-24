function decodedResult = Run_Length_Decoder(compr_String, max_run_length)
% The decoder considers the fact that each digit in compr_String indicates
% that many number of 0s followed by 1. 
tempDecodedResult = [];

% loop over all bits in compr_String
for idx = 1 : length(compr_String)
    zeroCount = 0;
    
    while (zeroCount ~= compr_String(idx))
        % Keep appending 0 to tempDecodedResult and incrementing zeroCount,
        % until we have the same number of 0s in tempDecodedResult as
        % specified by the index in compr_String
        tempDecodedResult = [tempDecodedResult, 0];
        zeroCount = zeroCount + 1;
    end
    if (max_run_length ~= compr_String(idx))
        % Only append 1 when the number in compr_String is not equal max_run_length
        % Append the terminating 1 for each run in tempDecodedResult
        tempDecodedResult = [tempDecodedResult, 1];
    end
end

% Remove the last 1 from the decoded result. This 1 was initially added by
% the encoder to to aid with the compression
tempDecodedResult = tempDecodedResult(1 : end - 1);
decodedResult = tempDecodedResult;
end