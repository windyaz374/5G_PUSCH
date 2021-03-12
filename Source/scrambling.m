function bq = scrambling(in,nRNTI,nID)
in = in';
%creat scrambling sequence
cinit = nRNTI*2^15 + nID;
c = sequence_gen(cinit,length(in));
bq = mod(in+c,2);
% Replace UCI placeholders having tag 'x' (input value is -1)
bq(in==-1)=1;
% Replace UCI placeholders having tag 'y' (input value is -2). Assume
% previous bit is 0
yidx = find(in==-2);
yfirst = (yidx==1);
bq(yidx(yfirst)) = 0;
bq(yidx(~yfirst)) = bq(yidx(~yfirst) - 1);
bq = bq';
end

