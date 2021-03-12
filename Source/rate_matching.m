function f = rate_matching(d,NPrb,Nl,ILbrm,rv,Qm,NREperPRB,LDPCgraph,C,Zc)
%Refer to 38.212-5.4.2
%d is input sequence d1,d2,...dN
%Nl is number of layers
%ILbrm is limited buffer rate matching parameter
%rv is redundancy version
%Qm is modulation order
%A is length of TBS
%LDPCgraph is type of base graph. Ex: LDPCgraph = 'type1'
%C is number of code blocks
%Zc is maximim LDPC lifting size or expansion factor
%f is output sequence f1,f2,...fE
%------------------------------------------------------------------------
%Determine E
A = NREperPRB*Qm*Nl*NPrb;
d = d';
RLbrm = 2;
if ILbrm == 0
    Ncb = length(d{1});
else
    Nref = floor(A/(C*RLbrm));
    Ncb = min(length(d{1}),Nref);
end

j = 0;
for i = 1:C
    if j <= (C-mod(A/(Nl*Qm),C)-1);
        E(i) = Nl*Qm*floor(A/(Nl*Qm*C));
    else
        E(i) = Nl*Qm*ceil(A/(Nl*Qm*C));
    end
    j = j+1;
end

k0 = sta_pos(rv,Ncb,LDPCgraph,Zc);
e = cell(1,C);
f = cell(1,C);
for i = 1:C
    e{i} = select_bit(d{i},E(i),k0,Ncb);
    f{i} = interleaving(e{i},E(i),Qm);
    f{i} = f{i}';
end
end

%%function to determine starting position of difference rv
function k0 = sta_pos(rv,Ncb,LDPCgraph,Zc)
switch LDPCgraph
        case 'type1'
            switch rv
                case 0
                    k0 = 0;
                case 1
                    k0 = floor(17*Ncb/(66*Zc))*Zc;
                case 2
                    k0 = floor(33*Ncb/(66*Zc))*Zc;
                case 3
                    k0 = floor(56*Ncb/(66*Zc))*Zc;
            end 
        case 'type2'
            switch rv
                case 0
                    k0 = 0;
                case 1
                    k0 = floor(13*Ncb/(50*Zc))*Zc;
                case 2
                    k0 = floor(25*Ncb/(50*Zc))*Zc;
                case 3
                    k0 = floor(43*Ncb/(50*Zc))*Zc;
            end
end
end

%%Bit selection
function out = select_bit(x,E,k0,Ncb)
k = 0;
j = 0;
while (k < E)
    if x(mod(k0+j,Ncb)+1)~= -1
        out(k+1) = x(mod(k0+j,Ncb)+1);
        k = k+1;
    end
    j = j+1;
end
end

%%Bit Interleaving
function out = interleaving(x,E,Qm)
for j = 0:(E/Qm-1)
    for i = 0:Qm-1
        out(i+j*Qm+1) = x(i*E/Qm+1+j);
    end
end
end



