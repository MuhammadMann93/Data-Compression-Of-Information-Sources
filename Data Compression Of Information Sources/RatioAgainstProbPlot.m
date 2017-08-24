function RatioAgainstProbPlot()

clear clc

rl = [];
huff = [];

probOfZeros = [0.99, 0.965, 0.95, 0.925, 0.90, 0.875, 0.85, 0.825, 0.80];

for i = 1 : length(probOfZeros)
    [r, h] = RunLengthPerformanceTest(probOfZeros(i));
    rl = [rl, r];
    huff = [huff, h];
end

plot(probOfZeros, rl);
hold on
plot(probOfZeros, huff);
grid on
legend('Run-Length', 'Run-Length + Huffman');
xlabel('P0');
ylabel('Compression ratio');
title('Compression ratio comparison with different p0, file size = 10000, max-run-length = 15');
end