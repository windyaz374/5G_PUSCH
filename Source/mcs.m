function [Qm, R] = mcs(TP,tab,mcsidx)
mcstab = load('MCSTable.mat');
if ~TP        
    switch tab
        case 0 
            TB = mcstab.NTPtab1;
        case 1
            TB = mcstab.NTPtab2;
        otherwise
            TB = mcstab.NTPtab3;
    end

Qm = TB(mcsidx+1,2);
R = TB(mcsidx+1,3)/1024;
end