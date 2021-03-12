function g = cb_concatenation(f)
%Refer to 38.212-5.5
%Input: Bit sequence frk, for r=1,2,...,C and k=1,2..,Er
%Output: Bit sequence gk, for k=1,2,...,G
g = [];
for i  = 1:length(f)
    g = [g;f{i}];
end