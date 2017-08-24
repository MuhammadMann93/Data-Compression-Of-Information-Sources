function [l, CB] = Huffman(p)
%p=[0.3 0.23 0.22 0.2 0.05];
%p = [ 0.4 .3 .3]
[l, CB] = combineProbabilities(p, [], false);

lFinal = l;
CBFinal = CB;
end