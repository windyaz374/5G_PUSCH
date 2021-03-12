%%----------------------------CRC Block----------------------------------%%
function b=crc_block(a,blk)
a = a';
A = length(a);
% generate generator polynomials
g24A = [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];
g24B = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1];
g24C = [1 1 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 1 1 1];
g16 = [1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];
switch blk
    case '24A'
        L = length(g24A)-1;
        g = g24A;
    case '24B'
        L = length(g24B)-1;
        g = g24B;
    case '24C'
        L = length(g24C)-1;
        g = g24C;
    case '16'
        L = length(g16)-1;
        g = g16;
end
mseg = [a zeros(1,L)];
remBits = [0 mseg(1:L)];
    for i = 1:A
        divide = [remBits(2:end) mseg(i+L)];
        if divide(1) == 1
            remBits = rem(g+divide,2);
        else
            remBits = divide;
        end
    end
    crc = remBits(2:end);

    b = [a crc]';