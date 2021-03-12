function gridinslot = puschmapping(gridinslot,puschIdx,xpre)
for i = 1:length(xpre)
    gridinslot(puschIdx(i,2),puschIdx(i,1)) = xpre(i);
end
end