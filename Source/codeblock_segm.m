function [c,setIdx,Zc]=codeblock_segm(LDPCgraph,b)
%LDPCgraph is type of base graph. Ex: LDPCgraph = 'type1'
%b is input sequence
B = length(b);
%Determine the max size of the code block (Kcb) and Kb
if LDPCgraph == 'type1'
    Kcb = 8448;
    Kb = 22;
else
    Kcb = 3840;
    if B > 640 
        Kb = 10;
    elseif B > 560
        Kb = 9;
    elseif B > 192
        Kb = 8;
    else
        Kb = 6;
    end
end
%Determine the number of Codeblocks
if B < Kcb
    L = 0;
    C = 1;
    B_prime = B;      %No Segmentation
else 
    L = 24;
    C = ceil(B/(Kcb-L));
    B_prime  = B + C*L;
end
%Determine the number of bits in each block (have CRC)
K_prime = B_prime/C;
%Determine the base matrix expansion factor Zc by selecting the minimum Zc
%Kb×Zc >= K_prime
load('LDPCliftsize.mat');
si = size(LDPCliftsize);
%si(1)
%si(2)
%for i=2:si(1)
%    for j=1:si(2)
%        Zc=LDPCliftsize(i,j);
%        if Zc >= K_prime/Kb;
%            break
%        end
%    end
%end
%setIdx = LDPCliftsize(1,j);
% = LDPCliftsize(i,j);

array = LDPCliftsize(LDPCliftsize>=K_prime/Kb);
Zc = min(array);
for i=2:si(1)
    for j=1:si(2)
        %LDPCliftsize(i,j)
        if LDPCliftsize(i,j) == Zc;
            setIdx = LDPCliftsize(1,j);
        end
    end
end

if LDPCgraph == 'type1' K=22*Zc; else K=10*Zc; end
%perform segmentation and add CRC bits
c=cell(1,C);
for i=1:C
    if i==C
        c{1,i}=b((i-1)*(K_prime-L)+1:end);
    else
        c{1,i}=b(1+(i-1)*(K_prime-L):i*(K_prime-L));
    end
    if (C>1) c{1,i}=crc_block(c{1,i},'24B'); end
    %if (C>1)&(i~=C) c{1,i}=crc_block(c{1,i},'24B'); end
    %if (C>1)&(i~=C) c{1,i}=nrCRCEncode(c{1,i},'24B'); end
    %length(c{1,i})
    c{1,i}(end+1:K)=-1;
end
end
    
        
    
    
 
 