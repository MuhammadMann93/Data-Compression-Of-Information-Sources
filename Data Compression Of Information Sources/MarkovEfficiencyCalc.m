%% Function to calculate the entroy rate of run length encoder 
% Uses probabilities to show the maximum compression that can be acheived
% with code
function EntropyRate = MarkovEfficiencyCalc(ProbZeroAtZero, ProbOneAtOne)
%%
ProbZeroAtOne = 1 - ProbOneAtOne; 
ProbOneAtZero = 1 - ProbZeroAtZero; 

pieZero = ProbZeroAtOne / (ProbZeroAtOne + ProbOneAtZero); 
pieOne = 1 - pieZero; 

EntropyRate = pieZero * (ProbZeroAtZero * log2(1/ProbZeroAtZero) + ProbOneAtZero * log2(1/ProbOneAtZero)) + pieOne * (ProbOneAtOne * log2(1/ProbOneAtOne) + ProbZeroAtOne * log2(1/ProbZeroAtOne)); 

end 