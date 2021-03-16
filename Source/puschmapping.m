function gridinslot = puschmapping(gridinslot,puschIdx,xpre)
kth = size(xpre);
for j = 1:kth(2)
    for i = 1:kth(1)
        gridinslot(puschIdx(i,2),puschIdx(i,1),j) = xpre(i,j);
    end
end
end