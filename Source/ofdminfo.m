function info = ofdminfo(NbwpPrb,mu,cptype)
info.SymbolsPerSubframe = 2^mu*14;
info.Nfft = power(2,ceil(log2(NbwpPrb*12/0.85)));
info.Nfft = max(128,info.Nfft);
info.scs = 2^mu*15*1000;
info.SamplingRate = info.Nfft*info.scs;
info.Windowing = max(0,8-2*(11-(log2(info.Nfft))));
scsScale = 2^mu;
xcp = 512*ones(1,info.SymbolsPerSubframe);
if (cptype == 0)
    xcp = 144*ones(1,info.SymbolsPerSubframe);
    xcp([1 length(xcp)/2+1]) = 160 + (scsScale-1)*16;
end
xcp = info.Nfft/2048*xcp;
info.CyclicPrefixLengths = xcp;
info.SymbolLengths = xcp + info.Nfft;
info.NSubcarriers = 12*NbwpPrb;

if (cptype)
    info.SymbolsPerSlot = 12;
else 
    info.SymbolsPerSlot = 14;
end

if (mu == 0)    info.SlotsPerSubframe = 1;
else            info.SlotsPerSubframe = 2*mu;
end

info.SymbolsPerSubframe =  info.SymbolsPerSlot*info.SlotsPerSubframe;
info.SamplesPerSubframe = sum(info.CyclicPrefixLengths) + info.SymbolsPerSubframe*info.Nfft;
info.SubframePeriod = double(info.SamplesPerSubframe) / info.SamplingRate;
end