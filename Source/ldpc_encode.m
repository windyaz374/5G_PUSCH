function d=ldpc_encode(c,LDPCgraph,setIdx,Zc)
%refer to 5.3.2 3gpp 38.212.
%c is input sequene (Kbits) and after encoding we have the sequence
%LDPCgraph is type of base graph. Ex: LDPCgraph = 'type1'
%Zc is maximim LDPC lifting size or expansion factor
%d (Nbits) is output sequence where N=66Zc for graph1 and N=50Zc for graph2
%---------------------------------------
c = c';
K = length(c);
for i = 2*Zc+1:K
    if c(i) ~= -1
        d(i-2*Zc) = c(i);
    else
        c(i) = 0;
        d(i-2*Zc) = -1;
    end
end

% Get the base matrix with base graph number 'ldpcgraph' and set number'setIdx'
BMatrix = base_matrix(LDPCgraph,setIdx);
[m,n] = size(BMatrix);

%Determine N+2Zc-K parity bits (p1,p2,.. where pi have Zc bits)
%cw = [input parity]
cw = zeros(1,Zc*n);
cw(1:(n-m)*Zc) = c;
%Refer double-diagnol encoding
%message*I(Pi,j)=message(Pi,j) where I(Pi,j) is obtained by circularly shifting the
%identity matrix I of size ZcxZc to the right Pi,j times and message(Pi,j)is obtained 
%by circularly shifting the identity matrix I of size ZcxZc to the left Pi,j times
%-----------------------------------------
%determine p1 
temp = zeros(1,Zc);
for i = 1:4 
    for j = 1:n-m
        %(j-1)*Zc+1:j*Zc
        %c
        %BMatrix(i,j)
        mul_shift(c((j-1)*Zc+1:j*Zc),BMatrix(i,j));
        temp = mod(temp + mul_shift(c((j-1)*Zc+1:j*Zc),BMatrix(i,j)),2);
    end
end
if BMatrix(2,n-m+1)==-1
    p1_sh = BMatrix(3,n-m+1);
else
    p1_sh = BMatrix(2,n-m+1);
end
cw((n-m)*Zc+1:(n-m+1)*Zc)= mul_shift(temp,Zc-p1_sh);

%determine p2,p3,p4
for i = 1:3
    temp = zeros(1,Zc);
    for j = 1:n-m+i
        temp = mod(temp + mul_shift(cw((j-1)*Zc+1:j*Zc),BMatrix(i,j)),2);
    end
    cw((n-m+i)*Zc+1:(n-m+i+1)*Zc) = temp;
end

%determine remain parity p5,p6...pm
for i = 5:m 
    temp = zeros(1,Zc);
    for j = 1:n-m+4
        temp = mod(temp + mul_shift(cw((j-1)*Zc+1:j*Zc),BMatrix(i,j)),2);
    end
    cw((n-m+i-1)*Zc+1:(n-m+i)*Zc) = temp;
end

%Add parity bits into d
d = [d cw((n-m)*Zc+1:end)]';
end




