function a=sequence_gen(cinit,Mnp)
Nc = 1600;
x1 = zeros(1,Nc + Mnp);
x2 = zeros(1,Nc + Mnp);
%generate the m-sequence: x1()
x1(1) = 1;
for n = 1:(Nc + Mnp - 31)
    x1(n+31) = mod(x1(n+3) + x1(n), 2);
end
%generate the m-sequence: x2()
x2(1:length(de2bi(cinit))) = de2bi(cinit);
for n = 1:(Nc + Mnp -31)
    x2(n+31) = mod(x2(n+3) + x2(n+2) + x2(n+1) + x2(n), 2);
end
%generate the resulting sequence: a()
for n = 1:Mnp
    a(n) = mod(x1(n+Nc) + x2(n+Nc), 2);
end
end
