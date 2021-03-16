%%-----------------------------------------------------------------------%%
%%-----------------------------TRANSMISTTER------------------------------%%
%%-----------------------------------------------------------------------%%
clc;
clear all;
parameter;
%% Determine modulation order and code rate
[para.Qm, para.R] = mcs(ue.TransformPrecoding,ue.McsTable,ue.Mcs); 

%% Determine TBSize
[para.TBSsize,para.NREperPRB,para.NDmrsperPrb] = tbs(ue.NPrb,ue.NPuschSymbAll,ue.Nlayers,ue.NPrbOh,para.Qm,para.R,ue.DmrsConfigurationType,ue.PuschMappingType,ue.DmrsDuration,ue.DmrsAdditionalPosition,ue.NumDmnrCdmGroupWithoutdata);

%% LDPC Base Graph Selection
 para.LDPCgraph = ldpcbasegraph(para.TBSsize,para.R);

%% PUSCH processing
para.nslots = 20;
puschgrid = [];
for k = 1:para.nslots
    if (mod(k-1,length(sys.rvSeq))+1 == 1)
        %% Generate Random Message
        %x.gen = randi([0 1],para.TBSsize,1);
        x.gen = ones(para.TBSsize,1);
        %% Transport Block CRC Attachment
        if (para.TBSsize > 3824)
            x.crc = crc_block(x.gen,'24A');
        else 
            x.crc = crc_block(x.gen,'16');
        end
        %% Code Block Segmentation
        [x.segment,para.setIdx,para.Zc] = codeblock_segm(para.LDPCgraph,x.crc);

        %% LDPC Encode
        para.ncodeblock = length(x.segment);
        x.ldpc = cell(1,para.ncodeblock);
        for i = 1:para.ncodeblock
            x.ldpc{i} = ldpc_encode(x.segment{i},para.LDPCgraph,para.setIdx,para.Zc);
        end
    end
    %% Rate Matching
    x.ratematching = rate_matching(x.ldpc,ue.NPrb,ue.Nlayers,ue.ILbrm,sys.rvSeq(mod(k-1,length(sys.rvSeq))+1),para.Qm,para.NREperPRB,para.LDPCgraph,para.ncodeblock,para.Zc);

    %% Code Block Concatenation
    x.cbconcatenation = cb_concatenation(x.ratematching);

    %% Scrambling
    x.scrambling = scrambling(x.cbconcatenation,ue.Rnti,ue.nId);

    %% Modulation
    x.modul = modulation(x.scrambling,para.Qm,ue.TransformPrecoding);

    %% Layer Mapping
    x.layermapping = layer_mapping(x.modul,ue.nCw,ue.Nlayers);

    %% Precoding
    [x.precoding,para.w] = precoding(x.layermapping,ue.CodeBookBased,ue.Nlayers,sys.NTxAnt,ue.Tpmi,ue.TransformPrecoding);

    %% Create resource grid and symbol mapping
    puschgrid = creategrid(para,x.precoding,puschgrid,k,para.w);
end
bwpgrid = zeros(12*sys.BwpNRb,14*para.nslots,sys.NTxAnt);
bwpgrid(1:12*ue.NPrb,1:14*para.nslots,1:sys.NTxAnt) = puschgrid;  
%% OFDM modulation
[waveform bwpset]=  ofdm_modulate(bwpgrid,sys.Numerology,sys.BwpNRb,sys.CpType,sys.NTxAnt);  

%% Plot the magnitude of the baseband waveform for the set of antenna ports defined
figure;
plot(abs(waveform));
title('Magnitude of 5G Uplink Baseband Waveform');
xlabel('Sample Index');
ylabel('Magnitude');


