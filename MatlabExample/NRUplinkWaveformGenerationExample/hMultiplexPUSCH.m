function cw = hMultiplexPUSCH(ulsch,ack,csi1,csi2,uciInfo,pusch,dmrs)
%hMultiplexPUSCH UCI and UL-SCH multiplexing onto PUSCH
%   CW = hMultiplexPUSCH(ULSCH,ACK,CSI1,CSI2,UCIINFO,PUSCH,DMRS)
%   returns the multiplexed ULSCH and UCI in a codeword CW as per TS
%   38.212 Section 6.2.7, with the following inputs:
%   ULSCH   - Coded UL-SCH bits. It is a column vector. Use empty ([])
%             to indicate no UL-SCH transmission.
%   ACK     - Coded ACK bits. It is a column vector. Use empty ([]) to
%             indicate no ACK transmission.
%   CSI1    - Coded CSI part1 bits. It is a column vector. Use empty ([])
%             to indicate no CSI part1 transmission.
%   CSI2    - Coded CSI part2 bits. It is a column vector. Use empty ([])
%             to indicate no CSI part2 transmission. Note that CSI2 is only
%             used when CSI1 is present.
%   UCIINFO - UCI information structure with the following fields
%        OACK    - Number of ACK bits. It is a scalar with value indicating
%                  the number of uncoded ACK bits.
%        Gackrvd - Number of reserved resource elements for HARQ-ACK. It is
%                  the bit capacity for HARQ-ACK when OACK is less than or
%                  equal to 2.
%   PUSCH   - PUSCH structure with the following fields
%        SubscriptIndices     - A two-column vector with first column
%                               providing the subcarrier indices and second
%                               column providing the symbol indices for
%                               PUSCH. All the indices are 1-based of one
%                               port. The subcarrier indices are relative
%                               to the start of resource block in each hop.
%        AllocatedSymbols     - The OFDM symbol indices allocated for
%                               PUSCH transmission in a slot (0-based),
%                               including those used for DM-RS. This is
%                               used only when SubscriptIndices
%                               is not provided.
%        AllocatedPRB         - The resource blocks allocated for
%                               PUSCH transmission in a slot (0-based).
%                               This is used only when SubscriptIndices is
%                               not provided.
%        Modulation           - Modulation scheme. It is one of the set
%                              {'pi/2-BPSK','QPSK','16QAM','64QAM','256QAM'}
%        NLayers              - Number of layers. It is in range 1...4
%        IntraSlotFreqHopping - Intra-slot frequency hopping. It is
%                               one of the set {'enabled','disabled'}
%   DMRS    - DM-RS indices structure with the following fields
%        SymbolIndices      - DM-RS symbol indices in the allocated symbols
%                             of PUSCH (0-based)
%        SubcarrierIndices  - DM-RS subcarrier indices per PRB in one OFDM
%                             symbol (0-based). It is either a column
%                             vector or a matrix with each column
%                             corresponding to a DM-RS port. This is used
%                             only when SubscriptIndices in PUSCH
%                             structures is not provided.
%
%   The length of the multiplexed output codeword CW is equal to the bit
%   capacity of PUSCH.
%
%   Note that the output CW contains extra zeros when there is no ULSCH to
%   achieve the required bit capacity.
%
%   Example 1:
%   % Get the multiplexed output of UCI without ULSCH for subsequent
%   % transmission on PUSCH using PUSCH subscript based indices.
%
%   ulsch = [];
%   ack = -1*ones(8,1);
%   csi1 = -2*ones(88,1);
%   csi2 = -3*ones(5720,1);
%
%   uciInfo = struct;
%   uciInfo.OACK = 1;
%   uciInfo.Gackrvd = 12;
%
%   pusch = struct;
%   subcarrierIndices = repmat((1:132)',11,1);
%   symbolIndices = reshape(repmat([1;2;4;5;6;7;9;10;11;13;14],1,132)',[],1);
%   pusch.SubscriptIndices = [subcarrierIndices symbolIndices];
%   pusch.Modulation = 'pi/2-BPSK';
%   pusch.NLayers = 2;
%   pusch.IntraSlotFreqHopping = 'disabled';
%
%   dmrs = struct;
%   dmrs.SymbolIndices = [2 7 11];
%
%   out = hMultiplexPUSCH(ulsch,ack,csi1,csi2,uciInfo,pusch,dmrs);
%
%   Example 2:
%   % Get the multiplexed output for the same parameters as example 1 with
%   % PUSCH resource allocation.
%
%   ulsch = [];
%   ack = -1*ones(8,1);
%   csi1 = -2*ones(88,1);
%   csi2 = -3*ones(5720,1);
%
%   uciInfo = struct;
%   uciInfo.OACK = 1;
%   uciInfo.Gackrvd = 12;
%
%   pusch = struct;
%   pusch.SubscriptIndices = [];
%   pusch.AllocatedSymbols = 0:13;
%   pusch.AllocatedPRB = 0:10;
%   pusch.Modulation = 'pi/2-BPSK';
%   pusch.NLayers = 2;
%   pusch.IntraSlotFreqHopping = 'disabled';
%
%   dmrs = struct;
%   dmrs.SymbolIndices = [2 7 11];
%   dmrs.SubcarrierIndices = 0:11;
%
%   out = hMultiplexPUSCH(ulsch,ack,csi1,csi2,uciInfo,pusch,dmrs);
%
%   See also nrPUSCH, nrULSCH, nrUCIEncode.

%   Copyright 2019 The MathWorks, Inc.

    narginchk(7,7);

    % Length(s) of coded ULSCH, HARQ-ACK and CSI
    fcnName = 'hMultiplexPUSCH';
    Gulsch = length(ulsch);
    Gack = length(ack);
    Gcsi1 = length(csi1);
    Gcsi2 = length(csi2);

    % Validate ulsch
    if Gulsch
        validateattributes(ulsch,{'numeric'},{'column'},fcnName,'ULSCH');
    end

    % Validate ack
    if Gack
        validateattributes(ack,{'numeric'},{'column'},fcnName,'ACK');
    end

    % Validate csi1
    if Gcsi1
        validateattributes(csi1,{'numeric'},{'column'},fcnName,'CSI1');
    end

    % Validate csi2
    if Gcsi2
        validateattributes(csi2,{'numeric'},{'column'},fcnName,'CSI2');
    end

    % Validate UCIINFO structure
    if isfield(uciInfo,'OACK')
        validateattributes(uciInfo.OACK,{'numeric'},{'scalar','integer','nonnegative'},...
            fcnName,'UCIINFO OACK');
    else
        error('The field OACK must be present in UCIINFO structure');
    end

    if isfield(uciInfo,'Gackrvd')
        if ~isempty(uciInfo.Gackrvd)
            validateattributes(uciInfo.Gackrvd,{'numeric'},{'scalar','integer'},...
                fcnName,'UCIINFO Gackrvd');
        end
    end

    % Initialize a flag to validate the PUSCH structure based on the
    % SubscriptIndices field
    subscriptIndicesFlag = 1;
    if isfield(pusch,'SubscriptIndices')
        if isempty(pusch.SubscriptIndices)
            subscriptIndicesFlag = 0;
        end
    else
        subscriptIndicesFlag = 0;
    end

    % Validate SubscriptIndices field of PUSCH structure
    if subscriptIndicesFlag
        validateattributes(pusch.SubscriptIndices,{'numeric'},...
            {'size',[nan 2],'integer','positive'},fcnName,'PUSCH Subscript indices');
    else
        % Validate the other fields in PUSCH and DMRS structure when
        % SubscriptIndices field of PUSCH is not present.
        if isfield(pusch,'AllocatedSymbols')
            validateattributes(pusch.AllocatedSymbols,{'numeric'},...
                {'vector','integer','nonnegative','<',14},fcnName,'PUSCH Allocated Symbols');
            if ~(all(diff(pusch.AllocatedSymbols)==1))
                error('The Allocated symbols of PUSCH must be contiguous.');
            end
        else
            error('The field AllocatedSymbols must be present in PUSCH structure.');
        end

        if isfield(pusch,'AllocatedPRB')
            validateattributes(pusch.AllocatedPRB,{'numeric'},...
                {'vector','integer','nonnegative'},fcnName,'PUSCH Allocated PRB');
        else
            error('The field AllocatedPRB must be present in PUSCH structure.');
        end

        if isfield(dmrs,'SubcarrierIndices')
            validateattributes(dmrs.SubcarrierIndices,{'numeric'},{'2d','nonempty',...
                '<=',11},fcnName,'DMRS Subcarrier indices');
        else
            error('The field SubcarrierIndices must be present in DMRS structure.');
        end
    end

    % Validate other fields of PUSCH structure
    if isfield(pusch,'Modulation')
        modulation = validatestring(pusch.Modulation,{'pi/2-BPSK','QPSK',...
            '16QAM','64QAM','256QAM'},fcnName,'PUSCH Modulation scheme');
    else
        error('The field Modulation must be present in PUSCH structure.');
    end

    if isfield(pusch,'NLayers')
        validateattributes(pusch.NLayers,{'numeric'},...
            {'scalar','integer','>=',1,'<=',4},fcnName,'PUSCH NLayers');
    else
        error('The field NLayers must be present in PUSCH structure.');
    end

    if isfield(pusch,'IntraSlotFreqHopping')
        intraSlotFreqHopping = validatestring(pusch.IntraSlotFreqHopping,...
            {'enabled','disabled'},fcnName,'PUSCH Intra-slot frequency');
    else
        error('The field IntraSlotFreqHopping must be present in PUSCH structure.');
    end

    % Validate DMRS structure
    if isfield(dmrs,'SymbolIndices')
        validateattributes(dmrs.SymbolIndices,{'numeric'},{'vector',...
            'nonempty'},fcnName,'DMRS Symbol indices');
    else
        error('The field SymbolIndices must be present in DMRS structure.');
    end

    % Length of HARQ-ACK bits
    oACK = uciInfo.OACK;

    % Check if oACK is zero and Gack is non-zero
    if oACK == 0 && Gack ~=0
        error('The number of coded HARQ-ACK (%d) bits must be zero when number of HARQ-ACK bits is zero.',Gack);
    end

    % Number of reserved resource elements for HARQ-ACK when number of
    % HARQ-ACK bits is no more than 2
    if isempty(uciInfo.Gackrvd) || ~isfield(uciInfo,'Gackrvd')
        GACKrvd = 0;
    else
        GACKrvd = uciInfo.Gackrvd;
    end

    % Check if oACK is less than 2 and Gackrvd is zero
    if oACK <= 2 && ~GACKrvd
        error('The input Gackrvd (%d) must be greater than zero, when number of HARQ-ACK bits (%d) is less than 2.',GACKrvd,oACK);
    end

    % Assign the fields of DMRS structure
    dmrsSym = dmrs.SymbolIndices;

    if subscriptIndicesFlag
        SymbolIndices = pusch.SubscriptIndices(:,2)-min(pusch.SubscriptIndices(:,2))+1;
        puschSym1 = unique(SymbolIndices)';                    % 1-based
        dmrsSym1 = dmrsSym-min(pusch.SubscriptIndices(:,2))+2; % Convert to 1-based

        % Get the subcarrier indices for UL-SCH on each OFDM symbol
        nPUSCHsymall = length(union(puschSym1,dmrsSym1));
        phiULSCH = cell(nPUSCHsymall,1);
        for i = 1:nPUSCHsymall
            phiULSCH{i} = zeros(0,1); % Initialize for codegen
        end
        for i = 1:length(puschSym1)
            phiULSCH{puschSym1(i)} = pusch.SubscriptIndices(SymbolIndices==puschSym1(i))-1;
        end
        for i = 1:length(dmrsSym1)
            phiULSCH{dmrsSym1(i)} = pusch.SubscriptIndices(SymbolIndices==dmrsSym1(i))-1;
        end

        k = unique(pusch.SubscriptIndices(:,1)); % Used to initialize gBar
    else
        % DMRS Subcarrier indices
        dmrsRE  = dmrs.SubcarrierIndices;

        % For type B, the start of PUSCH symbols need not be 0
        puschSym = setdiff(pusch.AllocatedSymbols-pusch.AllocatedSymbols(1), ...
            dmrsSym-pusch.AllocatedSymbols(1));

        % Convert the symbols into 1-based
        puschSym1 = puschSym+1;
        dmrsSym1 = dmrsSym+1-pusch.AllocatedSymbols(1);

        % Get the subcarrier indices for PUSCH allocation per OFDM symbol
        k = reshape(repmat((0:11)',1,length(pusch.AllocatedPRB)) + ...
            repmat(12*pusch.AllocatedPRB,12,1),[],1);

        % Get the subcarrier indices for UL-SCH on OFDM symbol carrying DM-RS
        kdmrs = setdiff(k,reshape((repmat(unique(dmrsRE(:)),1,length(pusch.AllocatedPRB))+ ...
            repmat(12*pusch.AllocatedPRB,length(unique(dmrsRE(:))),1)),[],1));

        % Get the subcarrier indices for UL-SCH on each OFDM symbol
        nPUSCHsymall = length(pusch.AllocatedSymbols);
        phiULSCH = cell(nPUSCHsymall,1);
        for i = 1:nPUSCHsymall
            phiULSCH{i} = zeros(0,1); % Initialize for codegen
        end
        for i = 1:length(puschSym1)
            phiULSCH{puschSym1(i)} = k;
        end

        for i = 1:length(dmrsSym1)
            phiULSCH{dmrsSym1(i)} = kdmrs;
        end
    end

    % Get the number of subcarriers for UL-SCH on each OFDM symbol
    mULSCH = zeros(nPUSCHsymall,1);
    for i = 1:nPUSCHsymall
        mULSCH(i) = length(phiULSCH{i});
    end

    phiUCI = phiULSCH;
    for i = 1:length(dmrsSym1)
        phiUCI{dmrsSym1(i)} = zeros(0,1);
    end

    mUCI = mULSCH;
    mUCI(dmrsSym1) = 0;

    % Get the parameters from pusch
    isFreqHopEnabled = strcmpi(intraSlotFreqHopping,'enabled');
    nlayers          = pusch.NLayers;
    qm               = nr5g.internal.getQm(modulation);
    nlqm = nlayers*qm;
    nlqm2 = 2*nlqm;

    % Initialize some parameters
    gBar = zeros(nPUSCHsymall,length(k),nlqm);
    Gack1 = Gack;
    Gcsi11 = Gcsi1;
    Gcsi21 = Gcsi2;
    Gack2 = 0;
    Gcsi12 = 0;
    Gcsi22 = 0;

    % Get the set of parameters in each hop
    if isFreqHopEnabled && length(puschSym1) > 1
        Nhop = 2;

        pusch1 = puschSym1(1:floor(length(puschSym1)/2));
        pusch2 = puschSym1(floor(length(puschSym1)/2)+1:end);
        l1 = pusch1(1);
        l2 = pusch2(1);
        if ~isempty(dmrsSym1)
            dmrs1 = dmrsSym1(1:floor(length(dmrsSym1)/2));
            dmrs2 = dmrsSym1(floor(length(dmrsSym1)/2)+1:end);

            l1(:) = pusch1(find(dmrs1(1)<pusch1,1));
            l2(:) = pusch2(find(dmrs2(1)<pusch2,1));
        end

        lcsi1 = pusch1(1);
        lcsi2 = pusch2(1);

        % HARQ-ACK with UL-SCH
        if Gack && Gulsch
            Gack1 = nlqm*floor(Gack/nlqm2);
            Gack2 = nlqm*ceil(Gack/nlqm2);
        end

        % CSI part 1 with UL-SCH
        if Gcsi1 && Gulsch
            Gcsi11 = nlqm*floor(Gcsi1/nlqm2);
            Gcsi12 = nlqm*ceil(Gcsi1/nlqm2);
        end

        % CSI part 2 with UL-SCH
        if Gcsi2 && Gulsch
            Gcsi21 = nlqm*floor(Gcsi2/nlqm2);
            Gcsi22 = nlqm*ceil(Gcsi2/nlqm2);
        end

        m1 = sum(mUCI(1:floor(nPUSCHsymall/2)));
        m2 = sum(mUCI(floor(nPUSCHsymall/2)+1:end));
        m3 = sum(mUCI(l1:floor(nPUSCHsymall/2)));
        if ~Gulsch
            % No UL-SCH transmission
            % CSI part 1 and CSI part 2 without HARQ-ACK
            if Gcsi1 && ~oACK
                Gackrvd1 = nlqm*floor(GACKrvd/nlqm2);
                Gcsi11 = min(nlqm*floor(Gcsi1/nlqm2), ...
                    m1*nlqm-Gackrvd1);
                Gcsi12 = Gcsi1 - Gcsi11;
                if Gcsi2
                    Gcsi21 = m1*nlqm - Gcsi11;
                    Gcsi22 = m2*nlqm - Gcsi12;
                end
            else
                % HARQ-ACK
                if Gack
                    Gack1 = min(nlqm*floor(Gack/nlqm2),...
                        m3*nlqm);
                    Gack2 = Gack - Gack1;
                end
                % CSI part 1
                if Gcsi1 && ~Gcsi2
                    Gcsi11 = m1*nlqm - Gack1;
                    Gcsi12 = Gcsi1 - Gcsi11;
                end
                % CSI part 1 and CSI part 2
                if Gcsi1 && Gcsi2
                    if oACK > 2
                        GackCSI1 = Gack1;
                    else
                        GackCSI1 = nlqm*floor(GACKrvd/nlqm2);
                    end
                    Gcsi11 = min(nlqm*floor(Gcsi1/nlqm2), ...
                        m1*nlqm-GackCSI1);
                    Gcsi12 = Gcsi1 - Gcsi11;
                    if oACK > 2
                        Gcsi21 = m1*nlqm - Gack1 - Gcsi11;
                        Gcsi22 = m2*nlqm - Gack2 - Gcsi12;
                    else
                        Gcsi21 = m1*nlqm - Gcsi11;
                        Gcsi22 = m2*nlqm - Gcsi12;
                    end
                end
            end
        end % if ~Gulsch
    else
        l1(:) = puschSym1(find(dmrsSym1(1)<puschSym1,1));
        lcsi1 = puschSym1(1);
        l2 = [];
        lcsi2 = [];
        Nhop = 1;
    end

    % Step 1
    phiBarULSCH = phiULSCH;
    mBarULSCH = mULSCH;

    % Initialize phiBarRvd to get the set of reserved elements in each OFDM
    % symbol
    phiBarRvd = cell(nPUSCHsymall,1);
    for i = 1:nPUSCHsymall
        phiBarRvd{i} = zeros(0,1);
    end

    % Set of reserved elements
    if oACK <= 2 && GACKrvd && Gack % Check only if Gack is greater than zero
        lprime = [l1 l2];
        if isFreqHopEnabled
            GACKrvd1 = nlqm*floor(GACKrvd/nlqm2);
            GACKrvd2 = nlqm*ceil(GACKrvd/nlqm2);
        else
            GACKrvd1 = GACKrvd;
            GACKrvd2 = 0;
        end

        mACKcount = [0 0];
        GACKrvdTemp = [GACKrvd1 GACKrvd2];

        for i = 1:Nhop
            sym = lprime(i);
            while mACKcount(i) < GACKrvdTemp(i)
                if sym > nPUSCHsymall
                    % Check for the symbol number greater than the number
                    % of PUSCH allocated symbols in each hop and avoid out
                    % of bounds indexing
                    break;
                end

                if mUCI(sym) > 0
                    % Total number of reserved elements remaining per hop
                    numACKRvd = GACKrvdTemp(i)-mACKcount(i);

                    if numACKRvd >= mUCI(sym)*nlqm
                        d = 1;
                        mREcount = mBarULSCH(sym);
                    else
                        d = floor((mUCI(sym)*nlqm)/numACKRvd);
                        mREcount = ceil(numACKRvd/nlqm);
                    end
                    phiBarRvd{sym} = phiBarULSCH{sym}((0:mREcount-1)*d+1);
                    mACKcount(i) = mREcount*nlqm;
                end
                sym = sym+1;
            end % while
        end % for Nhop
    end % if oACK

    % Number of reserved elements in each OFDM symbol
    mPhiSCRVD = zeros(nPUSCHsymall,1);
    for i = 1:nPUSCHsymall
        mPhiSCRVD(i) = length(phiBarRvd{i});
    end

    % Step 2
    % ACK (oACK > 2)
    if oACK > 2 && Gack
        GACKTemp = [Gack1 Gack2];
        lprime = [l1 l2];
        mACKcount = [0 0];
        mACKcountall = 0;
        for i = 1:Nhop
            sym = lprime(i);
            while mACKcount(i) < GACKTemp(i)
                if sym > nPUSCHsymall
                    % Check for the symbol number greater than the number
                    % of PUSCH allocated symbols in each hop and avoid out
                    % of bounds indexing
                    break;
                end

                if mUCI(sym) > 0
                    % Total number of remaining HARQ-ACK bits to be
                    % accommodated per hop
                    numACK = GACKTemp(i)-mACKcount(i);

                    if numACK >= mUCI(sym)*nlqm
                        d = 1;
                        mREcount = mUCI(sym);
                    else
                        d = floor((mUCI(sym)*nlqm)/numACK);
                        mREcount = ceil(numACK/nlqm);
                    end

                    % Place coded HARQ-ACK bits in gBar at relevant
                    % positions
                    k = phiUCI{sym}((0:mREcount-1)*d+1);
                    gBar(sym,k+1,1:nlqm) = reshape(ack(mACKcountall+(1:mREcount*nlqm)),nlqm,mREcount)';
                    mACKcountall = mACKcountall+(mREcount*nlqm);
                    mACKcount(i) = mACKcount(i)+(mREcount*nlqm);

                    phiUCItemp = phiUCI{sym}((0:mREcount-1)*d+1);
                    phiUCI{sym} = setdiff(phiUCI{sym},phiUCItemp);
                    phiBarULSCH{sym} = setdiff(phiBarULSCH{sym},phiUCItemp);
                    mUCI(sym) = length(phiUCI{sym});
                    mBarULSCH(sym) = length(phiBarULSCH{sym});
                end
                sym = sym+1;
            end % while
        end % for Nhop
    end % if oACK

    % Step 3
    % CSI
    if Gcsi1
        lprime = [lcsi1 lcsi2];
        mCSIcount = [0 0];
        mCSIcountall = 0;
        GCSI1Temp = [Gcsi11 Gcsi12];
        for i = 1:Nhop
            sym = lprime(i);
            while mUCI(sym)-mPhiSCRVD(sym) <= 0
                sym = sym+1;
            end
            while mCSIcount(i) < GCSI1Temp(i)
                if sym > nPUSCHsymall
                    % Check for the symbol number greater than the number
                    % of PUSCH allocated symbols in each hop and avoid out
                    % of bounds indexing
                    break;
                end

                % Number of resource elements available for CSI part 1 in
                % each symbol
                mUCIDiffmPhiRvd = mUCI(sym)-mPhiSCRVD(sym);

                % Total number of remaining CSI part 1 bits to be
                % accommodated per hop
                numCSI1 = GCSI1Temp(i)-mCSIcount(i);

                if mUCIDiffmPhiRvd > 0
                    if numCSI1 >= mUCIDiffmPhiRvd*nlqm
                        d = 1;
                        mREcount = mUCIDiffmPhiRvd;
                    else
                        d = floor((mUCIDiffmPhiRvd*nlqm)/numCSI1);
                        mREcount = ceil(numCSI1/nlqm);
                    end
                    phitemp = setdiff(phiUCI{sym},phiBarRvd{sym});

                    % Place coded CSI part 1 bits in gBar at relevant
                    % positions
                    k = phitemp((0:mREcount-1)*d+1);
                    gBar(sym,k+1,1:nlqm) = reshape(csi1(mCSIcountall+(1:mREcount*nlqm)),nlqm,mREcount)';
                    mCSIcountall = mCSIcountall+(mREcount*nlqm);
                    mCSIcount(i) = mCSIcount(i)+(mREcount*nlqm);

                    phiUCItemp = phitemp((0:mREcount-1)*d+1);
                    phiUCI{sym} = setdiff(phiUCI{sym},phiUCItemp);
                    phiBarULSCH{sym} = setdiff(phiBarULSCH{sym},phiUCItemp);
                    mUCI(sym) = length(phiUCI{sym});
                    mBarULSCH(sym) = length(phiBarULSCH{sym});
                end % end if
                sym = sym+1;
            end % while
        end % for Nhop

        % CSI part 2
        if Gcsi2
            mCSIcount = [0 0];
            mCSIcountall = 0;
            GCSI2Temp = [Gcsi21 Gcsi22];
            for i = 1:Nhop
                sym = lprime(i);
                while mUCI(sym) <= 0
                    sym = sym+1;
                end
                while mCSIcount(i)<GCSI2Temp(i)
                    if sym > nPUSCHsymall
                        % Check for the symbol number greater than the
                        % number of PUSCH allocated symbols in each hop and
                        % avoid out of bounds indexing
                        break;
                    end

                    if mUCI(sym) > 0
                        % Total number of CSI part 2 bits remaining to be
                        % accommodated per hop
                        numCSI2 = GCSI2Temp(i)-mCSIcount(i);

                        if numCSI2 >= mUCI(sym)*nlqm
                            d = 1;
                            mREcount = mUCI(sym);
                        else
                            d = floor((mUCI(sym)*nlqm)/numCSI2);
                            mREcount = ceil(numCSI2/nlqm);
                        end

                        % Place coded CSI part 2 bits in gBar at relevant
                        % positions
                        k = phiUCI{sym}((0:mREcount-1)*d+1);
                        gBar(sym,k+1,1:nlqm) = reshape(csi2(mCSIcountall+(1:mREcount*nlqm)),nlqm,mREcount)';
                        mCSIcountall = mCSIcountall+(mREcount*nlqm);
                        mCSIcount(i) = mCSIcount(i)+(mREcount*nlqm);

                        phiUCItemp = phiUCI{sym}((0:mREcount-1)*d+1);
                        phiUCI{sym} = setdiff(phiUCI{sym},phiUCItemp);
                        phiBarULSCH{sym} = setdiff(phiBarULSCH{sym},phiUCItemp);
                        mUCI(sym) = length(phiUCI{sym});
                        mBarULSCH(sym) = length(phiBarULSCH{sym});
                    end % if
                    sym = sym+1;
                end % while
            end  % for Nhop
        end % if GCSI2
    end % if GCSI1

    % Step 4
    % UL-SCH
    mULSCHcount = 0;
    if Gulsch
        for sym = 0:nPUSCHsymall-1
            if mBarULSCH(sym+1) > 0

                % Place coded ULSCH bits in gBar at relevant positions
                k = phiBarULSCH{sym+1}(1:mBarULSCH(sym+1));
                gBar(sym+1,k+1,1:nlqm) = reshape(ulsch(mULSCHcount+(1:(mBarULSCH(sym+1)*nlqm))),nlqm,mBarULSCH(sym+1))';
                mULSCHcount = mULSCHcount+(mBarULSCH(sym+1)*nlqm);

            end % if
        end % for sym
    end % if Gulsch

    % Step 5
    % ACK (oACK <= 2)
    if oACK == 1 || oACK == 2
        lprime = [l1 l2];
        mACKcount = [0 0];
        mACKcountall = 0;
        GACKTemp = [Gack1 Gack2];
        for i = 1:Nhop
            sym = lprime(i);
            while mACKcount(i) < GACKTemp(i)
                if sym > nPUSCHsymall
                    % Check for the symbol number greater than the
                    % number of PUSCH allocated symbols in each hop and
                    % avoid out of bounds indexing
                    break;
                end

                if mPhiSCRVD(sym)>0
                    % Total number of remaining HARQ-ACK bits to be
                    % accommodated per hop
                    numACK = GACKTemp(i)-mACKcount(i);
                    if numACK >= mPhiSCRVD(sym)*nlqm
                        d = 1;
                        mREcount = mPhiSCRVD(sym);
                    else
                        d = floor((mPhiSCRVD(sym)*nlqm)/numACK);
                        mREcount = ceil(numACK/nlqm);
                    end

                    % Place coded HARQ-ACK bits in gBar at relevant
                    % positions
                    k = phiBarRvd{sym}((0:mREcount-1)*d+1);
                    gBar(sym,k+1,1:nlqm) = reshape(ack(mACKcountall+(1:mREcount*nlqm)),nlqm,mREcount)';
                    mACKcountall = mACKcountall+(mREcount*nlqm);
                    mACKcount(i) = mACKcount(i)+(mREcount*nlqm);

                end % if
                sym = sym+1;
            end % while
        end % for Nhop
    end % if oACK

    % Step 6
    % Return the multiplexed output
    if Gulsch || Gack || Gcsi1
        t = 0;
        cw = zeros(sum(mULSCH(:))*nlqm,1); % Initialize cw
        for sym = 0:nPUSCHsymall-1
            for j = 0:mULSCH(sym+1)-1
                k = phiULSCH{sym+1}(j+1);
                cw(t+1:t+nlqm) = gBar(sym+1,k+1,:);
                t = t+nlqm;
            end
        end
    else
        % Inputs ulsch, ack, csi1 are empty, return empty
        cw = zeros(0,1);
    end

end
