function puschgrid = creategrid(para,xprecoding,puschgrid,slotIdx)
    parameter;
    gridIdx.dmrs =  zeros(12*ue.NPrb,2);
    for i = 1:12*ue.NPrb/2
        gridIdx.dmrs(i,1) = 3;
        %gridIdx.dmrs(i,2) = 12*ue.NPrb - 2*(i-1);
        gridIdx.dmrs(i,2) = 1 + (i-1)*2;
    end
    for i = 12*ue.NPrb/2+1:12*ue.NPrb
        gridIdx.dmrs(i,1) = 12;
        %gridIdx.dmrs(i,2) = 12*ue.NPrb - 2*(i-12*ue.NPrb/2-1);
        gridIdx.dmrs(i,2) = 1 + (i-12*ue.NPrb/2-1)*2;
    end
    gridIdx.pusch = [];
    for i = [1 2 4 5 6 7 8 9 10 11 13 14]
        for j = 1:1:12*ue.NPrb
            gridIdx.pusch = [gridIdx.pusch;i j];
        end 
    end
    gridinslot = zeros(12*ue.NPrb,ue.NPuschSymbAll,sys.NTxAnt);
    gridinslot = dmrsmapping(gridinslot,gridIdx.dmrs,para.NDmrsperPrb,ue.NPrb,sys.Numerology,sys.CpType,ue.NnScIdId,ue.nScId,ue.NumDmnrCdmGroupWithoutdata,slotIdx);
    gridinslot = puschmapping(gridinslot,gridIdx.pusch,xprecoding);
    puschgrid = [puschgrid gridinslot]; 
end