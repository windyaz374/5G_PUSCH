function LDPCgraph = ldpcbasegraph(A,R)
if (A<=292)|((A<=3824)&(R<=0.67))|(R<=0.25)
    LDPCgraph = 'type2';
else
    LDPCgraph = 'type1';
end
end