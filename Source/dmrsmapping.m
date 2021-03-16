function [gridinslot,dmrsseq]= dmrsmapping(gridinslot,dmrsIdx,NDmrsperPrb,NPrb,u,cptype,NnScIdId,nScId,nCDM,slotIdx,NTxAnt,w)
slotIdx = mod(slotIdx-1,2^u*10);
uniq = unique(dmrsIdx(:,1))-1;
if (cptype==0)
    nsym = 14;
else 
    nsym = 12;
end
cn = cell(1,length(uniq));
dmrsseq = cell(1,length(uniq));

for i=1:length(uniq)
    cinit(i) = mod(2^17*(nsym*slotIdx+uniq(i)+1)*(2*NnScIdId+1)+2*NnScIdId+nScId,2^31);
    cn{i} = sequence_gen(cinit(i),2*NDmrsperPrb*NPrb/(length(uniq)*nCDM));
    for k = 1:(length(cn{i})/2)
        dmrsseq{i} = [dmrsseq{i};1/sqrt(2)*(1-2*cn{i}(2*k-1))+j*1/sqrt(2)*(1-2*cn{i}(2*k))];
    end  
end
seqcom = [];
for i=1:length(uniq)
    seqcom = [seqcom;dmrsseq{i}];
end
seqcom = w.*seqcom;
for p = 1:NTxAnt
    for i=1:length(seqcom)
        gridinslot(dmrsIdx(i,2),dmrsIdx(i,1),p) = seqcom(i,p);
    end
end
end