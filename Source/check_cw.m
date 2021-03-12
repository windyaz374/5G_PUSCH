function out=check_cw(B,Zc,c)
%B is base graph matrix
%Zc is maximim LDPC lifting size or expansion factor
%c is input sequence
[m,n] = size(B);

syn = zeros(m*Zc,1);
for i = 1:m
    for j = 1:n
        syn((i-1)*Zc+1:i*Zc) = mod(syn((i-1)*Zc+1:i*Zc)+mul_shift(c((j-1)*Zc+1:j*Zc),B(i,j))',2);
    end
end
if any(syn)
    out = 0;
else
    out = 1;
end