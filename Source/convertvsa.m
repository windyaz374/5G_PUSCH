function convertvsa(waveform,bwpset)
    
    Nfft = bwpset.Nfft;
    scs = bwpset.scs;
    nAnt = bwpset.NTxant;
    waveform = reshape(waveform,[],nAnt);
    waveform = repmat(waveform,[8 1]);
    InputZoom = uint8(1);
    InputCenter = 0;
    XDelta = 1/(Nfft*scs);
    XDomain = int16(2);
    XUnit = 'Sec';
    YUnit = 'V';
    
    switch nAnt
        case 1
            Y = single(waveform);
            save('test.mat','InputCenter','InputZoom','XDelta','XDomain','XUnit','YUnit','Y');
        case 2
            Y1 = single(waveform(:,1));
            Y2 = single(waveform(:,2));
            DataOverload1 = 0;
            DataOverload2 = 0;
            save('test.mat','InputCenter','InputZoom','XDelta','XDomain','XUnit','YUnit','Y1','Y2','DataOverload1','DataOverload2');
        case 4
            Y1 = single(waveform(:,1));
            Y2 = single(waveform(:,2));
            Y3 = single(waveform(:,3));
            Y4 = single(waveform(:,4));
            save('test.mat','InputCenter','InputZoom','XDelta','XDomain','XUnit','YUnit','Y1','Y2','Y3','Y4');

    end
end