function dq = modulation(in,Qm,trans_pre)
in = in';
if (Qm == 1) & (trans_pre == 0)
    fprintf('Can not modulate');
else
    switch Qm
        case 1             %pi/2 BPSK
            for j = 1:length(in)
                dq(j) = exp(i*pi/2*(mod(j,2)))/sqrt(2)*((1-2*in(j))-i*(1-2*in(j)));
            end
        case 2             %QPSK
            for j = 1:length(in)/2
                dq(j) = ((1-2*in(2*j-1))-i*(1-2*in(2*j)))/sqrt(2);
            end
        case 4             %16QAM
            for j = 1:length(in)/4
                dq(j) = ((1-2*in(4*j-3))*(2-(1-2*in(4*j-1)))-i*(1-2*in(4*j-2))*(2-(1-2*in(4*j))))/sqrt(10);
            end
        case 6             %64QAM
            for j = 1:length(in)/6
                dq(j) = ((1-2*in(6*j-5))*(4-(1-2*in(6*j-3))*(2-(1-2*in(6*j-1))))-i*(1-2*in(6*j-4))*(4-(1-2*in(6*j-2))*(2-(1-2*in(6*j)))))/sqrt(42);
            end
        case 8             %256QAM
            for j = 1:length(in)/8
                dq(i) = ((1-2*in(8*j-7))*(8-(1-2*in(8*j-5))*(4-(1-2*in(8*j-3))*(2-(1-2*in(8*j-1)))))-i*(1-2*in(8*j-6))*(8-(1-2*in(8*j-4))*(4-(1-2*in(8*j-2))*(2-(1-2*in(8*j))))))/sqrt(170);
            end
        otherwise
            fprintf('Can not modulae');
    end
end
dq = dq';
end
