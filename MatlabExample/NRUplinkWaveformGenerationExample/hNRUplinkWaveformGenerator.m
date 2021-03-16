%hNRUplinkWaveformGenerator Generate 5G NR uplink waveform
%
%   [WAVEFORM,GRIDSET] = hNRUplinkWaveformGenerator(WAVECONFIG) provides
%   the 5G NR uplink waveform WAVEFORM with the input WAVECONFIG. The
%   WAVECONFIG is a structure of structures with the following fields:
%   NCellID          - Physical layer cell identity. It is in range 0 to
%                      1007
%   ChannelBandwidth - Channel bandwidth in MHz
%   FrequencyRange   - Frequency range ('FR1','FR2'). The frequency range
%                      and the channel bandwidth must be a valid ones as
%                      per TS 38.101-1 for FR1 and 38.101-2 for FR2.
%   NumSubframes     - Number of 1ms subframes in generated waveform
%   DisplayGrids     - Display the grids after signal generation. It is
%                      either 0 or 1
%   Carriers         - Carrier(s) configuration. A structure array with the
%                      following fields:
%         SubcarrierSpacing - Subcarrier spacing configuration in kHz.
%                             Possible configurations 15,30,60,120 and 240
%                             for normal CP, and 60 for extended CP
%         NRB               - Number of resource blocks
%         RBStart           - Start of resource block for the carrier
%   BWP              - Bandwidth part configuration. A structure array with
%                      the following fields:
%         SubcarrierSpacing - Subcarrier spacing configuration in kHz.
%                             Possible configurations 15,30,60,120 and 240
%                             for normal CP, and 60 for extended CP. Note
%                             for each BWP with separate subcarrier
%                             spacing, there has to be a carrier with the
%                             same subcarrier spacing configuration
%         CyclicPrefix      - Cyclic prefix ('normal','extended')
%         NRB               - Number of resource blocks per bandwidth part
%         RBOffset          - Position of BWP in the carrier
%   PUCCH            - Physical uplink control channel configuration. A
%                      structure array with the following fields:
%         Enable               - Enable/Disable the PUCCH instance. It is
%                                either 0 or 1
%         BWP                  - Bandwidth part identity. It is indicated
%                                to which bandwidth part the PUCCH is
%                                configured
%         Power                - Power scaling (in dB)
%         AllocatedSlots       - Allocated slots with the period. A row
%                                vector indicating the slots within the
%                                repetition period
%         AllocatedPeriod      - Allocated slot period. Use empty ([]) for
%                                no repetition
%         RNTI                 - Radio network temporary identifier. It is
%                                in range 0 to 65535
%         NID                  - Scrambling identity. It is in range
%                                0 to 1023. Use empty ([]) to use
%                                physical layer cell identity NCellID
%         HoppingId            - Hopping identity. It is in range 0 to
%                                1023. It is used for formats 0/1/3/4. Use
%                                empty ([]) to use physical layer cell
%                                identity NCellID
%         NIDDMRS              - Scrambling identity. It is in range
%                                0 to 65535. Use empty ([]) to use for
%                                physical layer cell identity NCellID. It
%                                is used only for format 2
%         PowerDMRS            - Power scaling of DM-RS (in dB)
%         DedicatedResource    - Enable/Disable the dedicated resource. It
%                                is either 0 or 1. When the value is set to
%                                0, the PUCCH resource is based on the
%                                resource index as per TS 38.213, Section
%                                9.2.1
%         ResourceIndex        - Resource index for common resource. It is
%                                in range 0 to 15. The value is considered
%                                only when DedicatedResource is set to 0
%         StartPRB             - Index of first PRB prior to frequency
%                                hopping or for no frequency hopping
%         SecondHopPRB         - Index of first PRB after frequency hopping
%         IntraSlotFreqHopping - Intra-slot frequency hopping
%                                configuration. It is one of the set
%                                {'enabled',disabled'} 
%         GroupHopping         - Group hopping configuration. It is one of
%                                the set {'enable','disable','neither'}
%         PUCCHFormat          - PUCCH format number (0...4)
%         StartSymbol          - Starting symbol index in the slot
%         NrOfSymbols          - Number of OFDM symbols allocated for
%                                PUCCH. The sum of StartSymbol and
%                                NrOfSymbols should be less than the number
%                                of symbols in a slot
%         InitialCS            - Initial cyclic shift. It is applicable for
%                                formats 0 and 1. It is in range 0 to 11
%         OCCI                 - Orthogonal cover code index. It is
%                                applicable for formats 1 and 4. For format
%                                1, the range is in 0 to 6 and for format
%                                4, it must be less than the spreading
%                                factor
%         Modulation           - Modulation scheme. It is applicable for
%                                formats 3 and 4. It is either 'pi/2-BPSK'
%                                or 'QPSK'
%         NrOfRB               - Number of resource blocks. It is
%                                applicable for formats 2 and 3. It is one
%                                of the set {1,2,3,4,5,6,8,9,10,12,15,16}
%         SpreadingFactor      - Spreading factor. It is applicable for
%                                format 4. The value is either 2 or 4
%         AdditionalDMRS       - Additional DM-RS configuration. It is
%                                applicable for formats 3 and 4. It is
%                                either 0 or 1
%         NrOfSlots            - Number of slots for repetition. It is one
%                                of the set (1,2,4,8). Use 1 for no
%                                repetition. For any other value, the
%                                values in the AllocatedSlots are treated
%                                as the start of the slot for the
%                                repetition. These slots are then repeated
%                                over the period
%         InterSlotFreqHopping - Inter-slot frequency hopping
%                                configuration. It is one of the set
%                                {'enabled',disabled'}. When the value is
%                                set to 'enabled', intra-slot frequency
%                                hopping is considered as disabled
%         MaxCodeRate          - Maximum code rate. It is one of the set
%                                {0.08, 0.15, 0.25, 0.35, 0.45, 0.6, 0.8}.
%                                This parameter is used when there is
%                                multiplexing of UCI-part1 and UCI-part2
%         LenACK               - Number of hybrid automatic repeat request
%                                acknowledgment (HARQ-ACK) bits. For
%                                formats 0 and 1, the maximum value can be
%                                2. For other formats, there is no
%                                restriction. Set the value to 0, for no
%                                HARQ-ACK transmission
%         LenSR                - Number of scheduling request (SR) bits.
%                                For formats 0 and 1, the maximum value can
%                                be 1. Set the value to 0, for no SR
%                                transmission
%         LenCSI1              - Number of CSI part 1 bits. It is
%                                applicable for formats 2,3 and 4. Set the
%                                value to 0, for no CSI part 1
%                                transmission
%         LenCSI2              - Number of CSI part 2 bits. It is
%                                applicable for format 3 and 4. Set the
%                                value to 0, for no CSI part 2
%                                transmission. This value is ignored if
%                                there is no CSI part 1 bits
%       Note that the UCI multiplexing happens on PUCCH when LenCSI2 is not
%       zero for formats 3 and 4.
%         DataSource           - UCI data source. Use one of the following
%                                standard PN sequences: 'PN9-ITU', 'PN9',
%                                'PN11', 'PN15', 'PN23'. The seed for the
%                                generator can be specified using a cell
%                                array in the form {'PN9',seed}. If no seed
%                                is specified, the generator is initialized
%                                with all ones
%   PUSCH    - Physical uplink shared channel configuration. A structure
%              array with the following fields:
%         Enable               - Enable/Disable the PUSCH configuration. It
%                                is either 0 or 1
%         BWP                  - Bandwidth part identity. It is indicated
%                                to which bandwidth part PUSCH is
%                                configured
%         Power                - Power scaling (in dB)
%         TargetCodeRate       - Code rate used to calculate transport
%                                block sizes
%         Xoh_PUSCH            - Overhead parameter. It is one of the set
%                                {0,6,12,18}
%         TxScheme             - Transmission scheme. It is one of the set
%                                {'codebook','nonCodebook'}. When set to
%                                codebook, the precoding matrix is applied
%                                based on the number of layers and the
%                                antenna ports
%         Modulation           - Modulation scheme. It is one of the set
%                                {'pi/2-BPSK','QPSK','16QAM','64QAM','256QAM'}
%         NLayers              - Number of layers. It is in range 1 to 4
%         NAntennaPorts        - Number of antenna ports. It is one of the
%                                set {1,2,4}
%         RVSequence           - Redundancy version sequence. it is applied
%                                cyclically across the PUSCH allocation
%                                sequence
%         IntraSlotFreqHopping - Intra-slot frequency hopping
%                                configuration. It is one of the set
%                                {'enabled',disabled'}
%         TransformPrecoding   - Transform precoding flag. It is either 0
%                                or 1. When set to 1, DFT operation is
%                                applied before precoding and it is only
%                                used for single layer
%         TPMI                 - Transmitted precoding matrix indicator.
%                                The range depends on the number of layers
%                                and antenna ports
%         GroupHopping         - Group hopping configuration. It is one of
%                                the set {'enable','disable','neither'}
%         RBOffset             - Resource block offset for second hop
%         InterSlotFreqHopping - Inter-slot frequency hopping
%                                configuration. It is one of the set
%                                {'enabled',disabled'}. When the value is
%                                set to 'enabled', intra-slot frequency
%                                hopping is considered as disabled
%         NID                  - Scrambling identity. It is in range
%                                0 to 1023. Use empty ([]) to use physical
%                                layer cell identity
%         RNTI                 - Radio network temporary identifier
%         DataSource           - Transport block data source. Use one of
%                                the following standard PN sequences:
%                                'PN9-ITU', 'PN9', 'PN11', 'PN15', 'PN23'.
%                                The seed for the generator can be
%                                specified using a cell array in the form
%                                {'PN9',seed}. If no seed is specified, the
%                                generator is initialized with all ones
%         PUSCHMappingType     - PUSCH mapping type. It is either 'A' or
%                                'B'. The number of symbols in a slot and
%                                the start symbol depends on the mapping
%                                type
%         AllocatedSymbols     - Symbols in a slot. It needs to be a
%                                contiguous allocation. For PUSCH mapping
%                                type 'A', the start symbol must be zero
%                                and the length can be from 4 to 14 (for
%                                normal CP) and up to 12 (for extended CP)
%         AllocatedSlots       - Slots in a frame used for PUSCH
%         AllocatedPeriod      - Allocation period in slots. Use empty for
%                                no repetition
%         AllocatedPRB         - PRB allocation
%         PortSet              - DM-RS ports to use for the layers
%         DMRSTypeAPosition    - DM-RS symbol position for mapping type
%                                'A'. It is either 2 or 3
%         DMRSLength           - Number of front-loaded DM-RS symbols. It
%                                is either 1 (single symbol) or 2 (double
%                                symbol)
%         DMRSAdditionalPosition  - Additional DM-RS symbols positions. It
%                                   is in range 0 to 3. Value of zero
%                                   indicates no additional DM-RS symbols
%         DMRSConfigurationType   - DM-RS configuration type. It is either
%                                   1 or 2. The number of subcarriers
%                                   allocated for DM-RS depends on the type
%         NumCDMGroupsWithoutData - Number of DM-RS CDM groups without
%                                   data. It is value in range 1 to 3. This
%                                   helps in reserving the resource
%                                   elements in the DM-RS carrying symbols
%                                   to avoid data transmission
%         NIDNSCID             - Scrambling identity for CP-OFDM DMRS. It
%                                is in range 0 to 65535. Use empty ([]) to
%                                use physical layer cell identity NCellID
%         NSCID                - CP-OFDM DM-RS scrambling initialization.
%                                It is either 0 or 1
%         NRSID                - Scrambling identity for DFT-s-OFDM DM-RS.
%                                It is in range 0 to 1007. Use empty ([])
%                                to use the physical layer cell identity
%                                NCellID
%         PowerDMRS            - Power boosting for DM-RS (in dB)
%         DisableULSCH         - Disable UL-SCH on overlapping slots of
%                                PUSCH and PUCCH. It is either 0 or 1
%         BetaOffsetACK        - Power factor of HARQ-ACK
%         BetaOffsetCSI1       - Power factor of CSI part 1
%         BetaOffsetCSI2       - Power factor of CSI part 2
%         ScalingFactor        - Scaling factor
%
%   The parameters DisableULSCH, BetaOffsetACK, BetaOffsetCSI1,
%   BetaOffsetCSI2 and ScalingFactor are used to transmit UCI information
%   on PUSCH, whenever there is a overlapping in the slots of PUCCH and
%   PUSCH. The parameters can be set as per TS 38.212, Section
%   6.3.2.4.
%
%   For PUCCH resource with format as 1 or 3 or 4, repetition of slots and
%   inter-slot frequency hopping can be configured. In other cases, these
%   parameters are ignored.
%
%   Whenever there is a PUSCH and PUCCH in a same slot, only PUSCH is
%   transmitted with UCI information on PUSCH. In this case, the UCI
%   information is transmitted based on the PUSCH allocation.
%
%   For PUSCH multi-slot transmission, inter-slot frequency hopping can be
%   enabled, the starting PRB is the changed in each slot in the frame. The
%   slots with even indices start with RBStart and with odd indices starts
%   at sum of RBStart and RBOffset modulo NRB of associated BWP.
%
%   Copyright 2019 The MathWorks, Inc.

function [waveform,gridset] = hNRUplinkWaveformGenerator(waveconfig)


    % Unbundle the channel specific parameter structures for easier access
    carriers = waveconfig.Carriers;
    bwp = waveconfig.BWP;
    pucch = waveconfig.PUCCH;
    pusch = waveconfig.PUSCH;

    % Defaulting for the grid plotting
    if ~isfield(waveconfig,'DisplayGrids')
        waveconfig.DisplayGrids = 0;
    end

    % Check if NCellId is in valid range 0...1007
    if (waveconfig.NCellID < 0) || (waveconfig.NCellID > 1007)
        error('The NCellID must be in range 0 to 1007.');
    end

    % Cross-check the BWP and SCS carrier configurations
    carrierscs = [carriers.SubcarrierSpacing];
    for bp=1:length(waveconfig.BWP)
        % Map it into a SCS specific carrier level RE grid
        cidx = find(bwp(bp).SubcarrierSpacing == carrierscs,1);
        if isempty(cidx)
            error('A SCS specific carrier configuration for SCS = %d kHz has not been defined. This carrier definition is required for BWP %d.',bwp(bp).SubcarrierSpacing,bp);
        end
        % Record the carrier index associated with the BWP
        bwp(bp).CarrierIdx = cidx;
    end

    % Create BWP PRB resource grids
    ResourceGrids = arrayfun(@(bp)zeros(bp.NRB,waveconfig.NumSubframes*1*symbolsPerSlot(bp)*fix(bp.SubcarrierSpacing/15)),...
                                    bwp,'UniformOutput',false);

    % Create BWP subcarrier resource grids
    % Size ALL BWP RE grids by the number of layers/ports in the enabled PUSCH
    numBWP = length(bwp);
    ResourceElementGrids = cell(numBWP,1);
    maxlayers = ones(1,numBWP);
    for i =1:numBWP
        n = ones(1,length(pusch));
        for j = 1:length(pusch)
            if pusch(j).Enable
                if pusch(j).BWP == i
                   if (strcmpi(pusch(j).TxScheme,'codebook'))
                       numPorts = pusch(j).NAntennaPorts;
                       if isempty(numPorts) || numPorts <= 0
                           warning('For codebook based transmission, the number of antenna ports cannot be empty or non-positive. It is treated as 1 for PUSCH %d.',j);
                           pusch(j).NAntennaPorts = 1;
                           numPorts = 1;
                       end
                       n(j) = numPorts;
                   else
                       numLayers = pusch(j).NLayers;
                       if isempty(numLayers) || numLayers <= 0
                           warning('The number of layers cannot be empty or non-positive. It is treated as one for PUSCH %d.',j);
                           pusch(j).NLayers = 1;
                           numLayers = 1;
                       end
                       n(j) = numLayers;
                   end
                end
            end
        end
        maxlayers(i) = max(n);
        ResourceElementGrids{i} = zeros(bwp(i).NRB*12,waveconfig.NumSubframes*symbolsPerSlot(bwp(i))*fix(bwp(i).SubcarrierSpacing/15),maxlayers(i));
    end

    % Define channel plotting ID markers
    chplevel.PUCCH = 1.3;
    chplevel.PUSCH = 0.8;

    % Get the overlapped slots of PUCCH and PUSCH of a specific RNTI
    [overlapSlots,rnti] = getOverlapSlots(pucch,pusch,bwp,waveconfig.NumSubframes);

    % Process the set of PUCCH transmission sequences
    for nch = 1:length(pucch)

        % Get a copy of the current PUCCH channel parameters
        ch = pucch(nch);

        % Only process configuration if enabled
        if ~ch.Enable
            continue;
        end

        % Check the referenced BWP and PUCCH indices
        checkIndex('PUCCH',pucch,nch,'BWP',bwp);

        % Establish whether transport coding is enabled
        uciCoding = ~isfield(ch,'EnableCoding') || ch.EnableCoding;

        % Get the number of symbols per slot for the associated BWP (CP dependent)
        symbperslot = symbolsPerSlot(bwp(ch.BWP));

        % Get the PUCCH resource parameters
        if ~ch.DedicatedResource && (symbperslot == 14) % Common resource is used only for normal CP

            % If dedicated resource is disabled and normal cyclic prefix,
            % the resource configuration parameters will be accessed based
            % on the resource index (Section 9.2.1, TS 38.213)
            % The format of the PUCCH common resource is 0 or 1.
            resInfo = pucchCommonResource(ch.ResourceIndex,bwp(ch.BWP).NRB);

            % Assign the multi-slot parameters and scrambling identity
            resInfo.NrOfSlots = ch.NrOfSlots;
            resInfo.InterSlotFreqHopping = ch.InterSlotFreqHopping;
            if ~isempty(ch.HoppingId)
                resInfo.HoppingId = ch.HoppingId;
            else
                % If NID is not configured, physical layer cell identity
                % NCellID is used
                resInfo.HoppingId = waveconfig.NCellID;
            end
        else
            % The configuration parameters provided in the PUCCH channel
            % will be accessed.
            resInfo = ch;
            if (ch.PUCCHFormat ~= 0 && ch.PUCCHFormat ~= 1) && isempty(ch.NID)
                % If NID is not configured, physical layer cell identity
                % NCellID is used. It is used for formats 2/3/4.
                resInfo.NID = waveconfig.NCellID;
            end
            if ch.PUCCHFormat ~=2 && isempty(ch.HoppingId)
                % If HoppingId is not configured, physical layer cell
                % identity NCellID is used.
                resInfo.HoppingId = waveconfig.NCellID;
            end
            if ch.PUCCHFormat == 2 && isempty(ch.NIDDMRS)
                % If NIDDMRS is not configured, physical layer cell
                % identity NCellID is used.
                resInfo.NIDDMRS = waveconfig.NCellID;
            end
        end

        % Check whether inter-slot frequency hopping is enabled for
        % repetition of slots
        interSlotFreqHopping = 0;
        if strcmpi(resInfo.InterSlotFreqHopping,'enabled') && resInfo.NrOfSlots > 1 ...
            && (resInfo.PUCCHFormat == 1 || resInfo.PUCCHFormat == 3 || resInfo.PUCCHFormat == 4)
            resInfo.IntraSlotFreqHopping = 'disabled';
            interSlotFreqHopping = 1;
        end

        % Ensure the number of OFDM symbols allocated for the specific
        % PUCCH format doesn't exceed the possible symbol allocation.
        if resInfo.PUCCHFormat == 0 || resInfo.PUCCHFormat == 2
            % For format 0 and 2, the maximum number of OFDM symbols that
            % can be allocated is 2.
            if resInfo.NrOfSymbols < 1 || resInfo.NrOfSymbols > 2
                error('The number of symbols allocated for PUCCH %d format %d must be either 1 or 2',nch,resInfo.PUCCHFormat);
            end
        else
            % For formats 1/3/4, the maximum number of OFDM symbols that
            % can be allocated is 14 (normal CP) or 12 (extended CP).
            if resInfo.NrOfSymbols < 4 || resInfo.NrOfSymbols > symbperslot
                error('The number of symbols allocated for PUCCH %d format %d must be in range 4 and %d',nch,resInfo.PUCCHFormat,symbperslot);
            end
        end

        % Get the allocated PRB, symbols and slots
        allocatedPRB = prbValues(resInfo);
        allocatedSymbols = resInfo.StartSymbol:resInfo.StartSymbol+resInfo.NrOfSymbols-1;
        allocatedSlots = cell2mat(getControlAllocatedSlots(ch,bwp,waveconfig.NumSubframes));

        % Ensure the allocated PRB is within the bandwidth part
        if any(max(allocatedPRB) >= bwp(ch.BWP).NRB)
            error('The allocated PRB indices (0-based, largest value = %d) for PUCCH %d exceed the NRB (%d) for BWP %d.',max(allocatedPRB(:)), nch, bwp(ch.BWP).NRB, ch.BWP);
        end

        % Mark the PUCCH sequences for display in the BWP grids, for visualization purposes only
        if ~interSlotFreqHopping
            ResourceGrids{ch.BWP}(1+allocatedPRB(:,1)',...
                reshape(1+symbperslot*allocatedSlots + allocatedSymbols(1:floor(resInfo.NrOfSymbols/2))',1,[])) = chplevel.PUCCH;
            if strcmpi(resInfo.IntraSlotFreqHopping,'enabled')
                ResourceGrids{ch.BWP}(1+allocatedPRB(:,2)',...
                    reshape(1+symbperslot*allocatedSlots+allocatedSymbols(floor(resInfo.NrOfSymbols/2)+1:end)',1,[])) = chplevel.PUCCH;
            else
                ResourceGrids{ch.BWP}(1+allocatedPRB(:,1)',...
                    reshape(1+symbperslot*allocatedSlots+allocatedSymbols(floor(resInfo.NrOfSymbols/2)+1:end)',1,[])) = chplevel.PUCCH;
            end
        else
            ResourceGrids{ch.BWP}(1+allocatedPRB(:,1)',...
                reshape(1+symbperslot*allocatedSlots(1:2:end) + allocatedSymbols',1,[])) = chplevel.PUCCH;
            ResourceGrids{ch.BWP}(1+(allocatedPRB(:,2)+resInfo.SecondHopPRB)',...
                reshape(1+symbperslot*allocatedSlots(2:2:end) + allocatedSymbols',1,[])) = chplevel.PUCCH;
        end

        % Create a data source for this PUCCH sequence
        datasource = hVectorDataSource(ch.DataSource); 

        % Loop over all the PUCCH transmission occasions and write the encoded
        % UCI payloads into the resource elements of the associated PUCCH instances
        count = 0;
        for index = 1:length(allocatedSlots)

            % Check for overlapping slots of PUCCH and PUSCH, ignore the
            % PUCCH transmission for the overlapped slot and transmit the
            % UCI information of PUCCH on PUSCH.
            if any(allocatedSlots(index) == overlapSlots{ch.BWP,ch.RNTI == rnti{ch.BWP}})
                count = count+1;
                continue;
            end

            % Get the slot-oriented PUCCH indices, DM-RS indices and DM-RS symbol values
            nslot = mod(allocatedSlots(index),10*(bwp(ch.BWP).SubcarrierSpacing/15));      % Slot number in the radio frame
            resInfo.NSlot = nslot;
            [indicesInfo, dmrssym] = ...
                hPUCCHResources(struct('CyclicPrefix',bwp(ch.BWP).CyclicPrefix,...
                'RBOffset',carriers(bwp(ch.BWP).CarrierIdx).RBStart+bwp(ch.BWP).RBOffset,'SubcarrierSpacing',bwp(ch.BWP).SubcarrierSpacing),resInfo);

            % Get the HARQ-ACK information based on LenACK field
            if ch.LenACK > 0
                ack = datasource.getPacket(ch.LenACK);
            else
                ack = [];
            end

            % Get the SR information based on LenSR field
            if ch.LenSR > 0
                sr = datasource.getPacket(ch.LenSR);
            else
                sr = [];
            end

            if uciCoding
                % Encode UCI bits for PUCCH formats 2/3/4
                if resInfo.PUCCHFormat == 2 || resInfo.PUCCHFormat == 3 || resInfo.PUCCHFormat == 4

                    if ch.LenCSI1
                        % Get the CSI part 1 payload
                        csi1 = datasource.getPacket(ch.LenCSI1);

                        % Combine HARQ-ACK, SR and CSI part1 information to UCI part 1
                        uciBits = [ack;sr;csi1];

                        % Length of UCI part 1
                        lenUCI1 = length(uciBits);
                        if lenUCI1 <= 2
                            error('The number of UCI bits (HARQ-ACK and SR and CSI) transmitted on PUCCH %d formats (2/3/4) must be more than 2.',nch);
                        end
                        L = getCRC(lenUCI1);         % Get the CRC length for UCI part 1

                        % Get CSI part 2 bits, if present
                        if ch.LenCSI2
                            % If the CSI part 2 is less than 3 bits, then the zeros
                            % are appended to make the length as 3 and assign to
                            % UCI part 2
                            uciBits2 = [datasource.getPacket(ch.LenCSI2); zeros(3-ch.LenCSI2,1)];
                            L2 = getCRC(length(uciBits2));
                        end

                        % Get the rate matching value for each UCI part
                        G1 = indicesInfo.G;
                        G2 = 0;
                            % UCI multiplexing happens for format 3 and 4,
                            % provided no repetition of slots
                        if ch.LenCSI2 && (resInfo.PUCCHFormat == 3 || resInfo.PUCCHFormat == 4) && ~(resInfo.NrOfSlots > 1)
                            qm = sum(strcmpi(resInfo.Modulation,{'pi/2-BPSK','QPSK'}).*[1 2]);
                            G1 = min(indicesInfo.G,ceil((lenUCI1 + L)/ch.MaxCodeRate/qm)*qm);
                            G2 = indicesInfo.G - G1;
                        end

                        % Check if the input bits are greater than the bit
                        % capacity of PUCCH resource
                        if lenUCI1+L >= G1
                            error('The sum of number of UCI part 1 (HARQ-ACK, SR, CSI part 1) bits (%d) and the CRC bits (%d) must be less than the bit capacity (%d) for PUCCH %d.',lenUCI1,L,G1,nch);
                        end

                        if G2
                            if ch.LenCSI2+L2 >= G2
                                error('The sum of number of CSI part 2 bits (%d) and the CRC bits (%d) must be less than the bit capacity (%d) for PUCCH %d.',ch.lenCSI2,L2,G2,nch);
                            end
                        end

                        % Encode the UCI payload to match the PUCCH bit
                        % capacity
                        codedUCI1 = nrUCIEncode(uciBits,G1);
                        if G2 && resInfo.PUCCHFormat ~= 2
                            % Encode UCI part 2, for format 3 and 4
                            codedUCI2 = nrUCIEncode(uciBits2,G2);

                            % Multiplex the encoded UCI part 1 and UCI part 2,
                            % assign to a codeword.
                            if resInfo.PUCCHFormat == 3
                                nRBOrSf = resInfo.NrOfRB;
                            else
                                nRBOrSf = resInfo.SpreadingFactor;
                            end
                            dmrsSymInd = indicesInfo.AllocatedDMRSSymbols-resInfo.StartSymbol;
                            codeword = hMultiplexPUCCH(codedUCI1,codedUCI2,resInfo.Modulation,resInfo.NrOfSymbols,...
                                dmrsSymInd,resInfo.PUCCHFormat,nRBOrSf);
                        else
                            % If no UCI part 2, codeword is the encoded UCI
                            % part 1.
                            codeword = codedUCI1;
                        end
                    else
                        % If no CSI part 1 on formats 2/3/4, codeword contains
                        % UCI information of HARQ-ACK and SR provided the input
                        % length is greater than 2 bits.
                        if length(ack) + length(sr) > 2
                            uciBits = [ack;sr];
                            lenUCI1 = length(uciBits);
                            L = getCRC(lenUCI1);
                            if lenUCI1+L >= indicesInfo.G
                                error('The sum of number of UCI (HARQ-ACK, SR) bits (%d) and the CRC bits (%d) must be less than the bit capacity (%d) for PUCCH %d.',lenUCI1,L,indicesInfo.G,nch);
                            end
                            codeword = nrUCIEncode(uciBits,indicesInfo.G);
                        else
                            error('The number of UCI bits (HARQ-ACK and SR) transmitted on PUCCH (%d) formats (2/3/4) must be more than 2.',nch);
                        end
                    end
                end
            else
                % Get the PUCCH codeword directly from the data source
                codeword = datasource.getPacket(indicesInfo.G);
            end

            % Process the UCI codeword on PUCCH
            switch resInfo.PUCCHFormat
                case 0
                    % PUCCH format 0
                    hoppingId = resInfo.HoppingId;           % Scrambling identity (hoppingId or NCellID, depending)
                    symbols = nrPUCCH0(ack,sr,[resInfo.StartSymbol resInfo.NrOfSymbols],...
                        bwp(ch.BWP).CyclicPrefix,nslot,hoppingId,resInfo.GroupHopping,resInfo.InitialCS,resInfo.IntraSlotFreqHopping);
                case 1
                    % PUCCH format 1
                    hoppingId = resInfo.HoppingId;           % Scrambling identity (hoppingId or NCellID, depending)
                    symbols = nrPUCCH1(ack,sr,[resInfo.StartSymbol resInfo.NrOfSymbols],...
                        bwp(ch.BWP).CyclicPrefix,nslot,hoppingId,ch.GroupHopping,resInfo.InitialCS,resInfo.IntraSlotFreqHopping,resInfo.OCCI);
                case 2
                    % PUCCH format 2
                    symbols = nrPUCCH2(codeword,resInfo.NID,ch.RNTI);
                case 3
                    % PUCCH format 3
                    symbols = nrPUCCH3(codeword,resInfo.Modulation,resInfo.NID,ch.RNTI,resInfo.NrOfRB);
                otherwise
                    % PUCCH format 4
                    symbols = nrPUCCH4(codeword,resInfo.Modulation,resInfo.NID,ch.RNTI,resInfo.SpreadingFactor,resInfo.OCCI);
            end
            symbols = reshape(symbols,[],length(indicesInfo.AllocatedSymbols)); % Reshape the column vector into the number of OFDM symbols for UCI information

            % Combine PUCCH with existing grid
            offset = 1+(reshape(symbperslot*allocatedSlots(index) + indicesInfo.AllocatedSymbols',1,[])*12*bwp(ch.BWP).NRB);
            repucch = indicesInfo.AllocatedSubcarriers;
            if interSlotFreqHopping
                count = mod(count,resInfo.NrOfSlots);
                if mod(count,2)==1
                    repucch = indicesInfo.AllocatedSubcarriers + resInfo.SecondHopPRB*12;
                end
            end
            ResourceElementGrids{ch.BWP}(offset+repucch) = ResourceElementGrids{ch.BWP}(offset+repucch) + symbols*db2mag(ch.Power); 

            % Combine PUCCH DM-RS with the grid
            offset = 1+(reshape(symbperslot*allocatedSlots(index) + indicesInfo.AllocatedDMRSSymbols',1,[])*12*bwp(ch.BWP).NRB);
            redmrs = indicesInfo.AllocatedDMRSSubcarriers;
            if interSlotFreqHopping
                count = mod(count,resInfo.NrOfSlots);
                if mod(count,2)==1
                    redmrs = indicesInfo.AllocatedDMRSSubcarriers + resInfo.SecondHopPRB*12;
                end
                count = count+1;
            end
            ResourceElementGrids{ch.BWP}(offset+redmrs) = ResourceElementGrids{ch.BWP}(offset+redmrs) + dmrssym*db2mag(ch.Power+ch.PowerDMRS);
        end
    % End of PUCCH sequence processing
    end

    % Process the set of PUSCH transmission sequences
    % Create a single UL-SCH channel processing object for use with all the PUSCH sequences
    ulsch = nrULSCH('MultipleHARQProcesses',false);

    for nch = 1:length(pusch)

        % Get a copy of the current PUSCH channel parameters
        ch = pusch(nch);

        % Only process configuration if enabled
        if ~ch.Enable
            continue;
        end

        % Establsh whether transport coding is enabled
        ulschCoding = ~isfield(ch,'EnableCoding') || ch.EnableCoding;

        % Check the referenced BWP index
        checkIndex('PUSCH',pusch,nch,'BWP',bwp);

        % Get the allocated slots for PUSCH
        allocatedSlots = cell2mat(getULSCHAllocatedSlots(ch,bwp,waveconfig.NumSubframes));

        % Ensure the allocated PRB is within the bandwidth part
        ch.AllocatedPRB = sort(ch.AllocatedPRB);
        if any(ch.AllocatedPRB >= bwp(ch.BWP).NRB)
            error('The allocated PRB indices (0-based, largest value = %d) for PUSCH %d exceed the NRB (%d) for BWP %d.',max(ch.AllocatedPRB),nch,bwp(ch.BWP).NRB,ch.BWP);
        end
        if strcmpi(ch.IntraSlotFreqHopping,'enabled') || strcmpi(ch.InterSlotFreqHopping,'enabled')
            if isempty(ch.RBOffset) % Replace the empty value with 0
                ch.RBOffset = 0;
            end
            secondHopPRB = mod(ch.AllocatedPRB(1)+ch.RBOffset,bwp(ch.BWP).NRB);
            secondHopPRBSet = secondHopPRB+ch.AllocatedPRB-ch.AllocatedPRB(1);
            ch.RBOffset = secondHopPRB; % Replace RB offset with the calculated secondHopPRB to pass into hPUSCHResources
        end
        % Ensure that the allocated symbols for the slot are within a slot for the BWP CP
        symbperslot = symbolsPerSlot(bwp(ch.BWP));
        slotsymbs = ch.AllocatedSymbols(ch.AllocatedSymbols < symbperslot);
        if length(slotsymbs) ~= length(ch.AllocatedSymbols)
            warning('The slot-wise symbol allocation for PUSCH %d in BWP %d includes 0-based symbol indices which fall outside a slot (0...%d). Using only symbols within a slot.',nch,ch.BWP,symbperslot-1);
            ch.AllocatedSymbols = slotsymbs;
        end

        % Ensure the allocated symbols are contiguous
        if any(diff(ch.AllocatedSymbols) ~= 1)
            error('The allocated symbols for PUSCH %d must be contiguous.',nch);
        end

        % Ensure the PUSCH allocation starts with symbol 0 and has minimum
        % length of 4 for mapping type 'A', as per TS 38.214, Section 6.1.2
        if strcmpi(ch.PUSCHMappingType,'A') 
            if ch.AllocatedSymbols(1) ~= 0
                error('For PUSCH mapping type A, the starting symbol must be 0.');
            end
            if length(ch.AllocatedSymbols) < 4
                error('For PUSCH mapping type A, the minimum number of allocated symbols must be 4.');
            end

            % Ensure the PUSCH with mapping type 'A' and intra-slot frequency
            % hopping enabled, has minimum of 8 symbols.
            if strcmpi(ch.IntraSlotFreqHopping,'enabled') && length(ch.AllocatedSymbols) < 8
                error('For PUSCH mapping type A with intra-slot frequency hopping enabled, the number of allocated OFDM symbols must be greater than or equal to 8.');
            end
        end

        % Ensure the number of DM-RS ports allocated is not less than the
        % number of layers
        if length(ch.PortSet) ~= ch.NLayers
            error('For PUSCH %d, the number of DM-RS ports (%d) must be equal to the number of layers (%d).',nch,length(ch.PortSet),ch.NLayers);
        end

        % Checks for number of DM-RS CDM groups without data
        if isempty(ch.NumCDMGroupsWithoutData) || ch.NumCDMGroupsWithoutData <= 0
            warning('For PUSCH %d, the number of DM-RS CDM groups without data is set to 1, as the value provided is either empty or less than 1.',nch);
            ch.NumCDMGroupsWithoutData = 1;  % Number of CDM groups is set to 1, when the value is less than, equal to zero or empty.
        end
        if ch.NumCDMGroupsWithoutData > 2 && ch.DMRSConfigurationType == 1
            error('For PUSCH %d, the maximum number of DM-RS CDM groups (%d) without data must be 2 when the DM-RS configuration type is 1.',nch,ch.NumCDMGroupsWithoutData);
        end
        if ch.NumCDMGroupsWithoutData > 3 && ch.DMRSConfigurationType == 2
            error('For PUSCH %d, the maximum number of DM-RS CDM groups (%d) without data must be 3 when the DM-RS configuration type is 2.',nch,ch.NumCDMGroupsWithoutData);
        end

        % Display related PRB level processing
        %
        % Calculate the *PRB* linear indices of all the PUSCH instances, primarily
        % for display purposes here.
        % This is performed by marking the allocated PRB in an empty PRB grid 
        % for the BWP in the entire waveform period, subtracting out the reserved
        % part then find the indices that have been used

        % Create an empty BWP spanning the length of the waveform
        rgrid = zeros(size(ResourceGrids{ch.BWP}));

        % Check if inter-slot frequency hopping is enabled
        interSlotFreqHopping = 0;
        if strcmpi(ch.InterSlotFreqHopping,'enabled')
            ch.IntraSlotFreqHopping = 'disabled';
            interSlotFreqHopping = 1;
        end

        % Mark the PRB/symbols associated with all the PUSCH instances in this sequence
        if ~interSlotFreqHopping
            if ~strcmpi(ch.IntraSlotFreqHopping,'enabled')
                for ns=allocatedSlots
                  rgrid(1+ch.AllocatedPRB,1+symbperslot*ns+ch.AllocatedSymbols) = 1;
                end
            else
                for ns=allocatedSlots
                  rgrid(1+ch.AllocatedPRB,1+symbperslot*ns+ch.AllocatedSymbols(1:floor(length(ch.AllocatedSymbols)/2))) = 1;
                  rgrid(1+secondHopPRBSet,1+symbperslot*ns+ch.AllocatedSymbols(floor(length(ch.AllocatedSymbols)/2)+1:end)) = 1;
                end
            end
        else
            for ns=allocatedSlots
                if mod(ns,2)==0
                  rgrid(1+ch.AllocatedPRB,1+symbperslot*ns+ch.AllocatedSymbols) = 1;
                else
                  rgrid(1+secondHopPRBSet,1+symbperslot*ns+ch.AllocatedSymbols) = 1;
                end
            end
        end

        % Identify all the indices that remain
        puschindices = find(rgrid);

        % Mark the used PUSCH locations in the PRB grid
        ResourceGrids{ch.BWP}(puschindices) = ResourceGrids{ch.BWP}(puschindices)+chplevel.PUSCH;

        % Waveform generation RE level processing
        %
        % The hPUSCHResources uses a slot-level set of parameters so map the
        % relevant parameter from the waveform level down to the slot level
        nrb = bwp(ch.BWP).NRB;
        ch.PRBSet = ch.AllocatedPRB;
        ch.SymbolSet = ch.AllocatedSymbols;
        ch.PRBRefPoint = carriers(bwp(ch.BWP).CarrierIdx).RBStart + bwp(ch.BWP).RBOffset;

        % Check for scrambling identities and configure physical layer cell
        % identity NCellID, if necessary
        if isempty(ch.NID)
            ch.NID = waveconfig.NCellID;
        end
        if ~ch.TransformPrecoding && isempty(ch.NIDNSCID)
            ch.NIDNSCID = waveconfig.NCellID;
        end
        if ch.TransformPrecoding && isempty(ch.NRSID)
            ch.NRSID = waveconfig.NCellID;
        end

        % Create a data source for this PUSCH sequence
        datasource = hVectorDataSource(ch.DataSource);

        % Configure the UL-SCH processing object for this PUSCH sequence
        if ulschCoding
            ulsch.TargetCodeRate = ch.TargetCodeRate;
        end

        % Get the PUCCH structures within the same BWP
        if ~isempty(overlapSlots{ch.BWP,ch.RNTI == rnti{ch.BWP}})
            id = cell2mat(arrayfun(@(x) getfield(pucch,{x},'BWP'),1:length(pucch),'UniformOutput',false)) == ch.BWP;
            for i = 1:length(id)
                if id(i) && pucch(i).Enable
                    if pucch(i).RNTI == ch.RNTI
                        pucchId = i;
                        break;
                    end
                end
            end
        end

        % Loop over all the allocated slots
        for i = 1:length(allocatedSlots)

            % Get current slot number
            s = allocatedSlots(i);
            ch.NSlot = s;

            % Create an empty slot grid to contain a single PUSCH instance
            slotgrid = zeros(12*nrb,symbperslot,maxlayers(ch.BWP));

            % Get the slot-oriented PUSCH indices, DM-RS indices and DM-RS symbol values  
            [puschREindices,dmrsREindices,dmrsSymbols,modinfo] = ...
                hPUSCHResources(struct('NRB',bwp(ch.BWP).NRB,'CyclicPrefix',bwp(ch.BWP).CyclicPrefix,'SubcarrierSpacing',bwp(ch.BWP).SubcarrierSpacing),ch);

            % Convert the puschREindices of one port to subscript form to
            % use directly in hMultiplexPUSCH
            [puschSubcarrierInd,puschSymInd] = ind2sub([12*bwp(ch.BWP).NRB symbperslot 1],puschREindices(:,1));
            if strcmpi(ch.IntraSlotFreqHopping,'enabled')
                puschSubcarrierInd(puschSymInd>floor(length(ch.SymbolSet))/2) = puschSubcarrierInd(puschSymInd>floor(length(ch.SymbolSet))/2)-secondHopPRB*12;
            end

            % Add the offset to odd numbered slots, when inter-slot
            % frequency hopping is enabled
            if interSlotFreqHopping
                if mod(s,2) == 1
                    puschREindices = puschREindices + 12*(secondHopPRB-ch.AllocatedPRB(1));
                    dmrsREindices = dmrsREindices + 12*(secondHopPRB-ch.AllocatedPRB(1));
                end
            end

            if ulschCoding
                % Get the RV value for this transmission instance
                rvidx = mod(i-1,length(ch.RVSequence))+1;
                rv = ch.RVSequence(rvidx);

                % For the first RV in a sequence, get a new transport block from 
                % the data source and pass it to the UL-SCH processing
                if rvidx == 1
                   trblksize = hPUSCHTBS(ch,modinfo.NREPerPRB-ch.Xoh_PUSCH);
                   %trblk = datasource.getPacket(trblksize);
                   trblk = ones(trblksize,1);
                   setTransportBlock(ulsch,trblk);
                end

                % Overlap slots with PUCCH - transmit PUSCH with UCI
                if any(allocatedSlots(i)==overlapSlots{ch.BWP,ch.RNTI == rnti{ch.BWP}})

                    if strcmpi(ch.PUSCHMappingType,'B') &&...
                            ((strcmpi(ch.IntraSlotFreqHopping,'enabled') && length(ch.AllocatedSymbols) < 3) ||...
                            length(ch.AllocatedSymbols) == 1)
                        disp(['The UCI information is ignored in the overlapping slot number ', num2str(allocatedSlots(i)),...
                            ' for PUSCH ',num2str(nch),' mapping type B configuration.']);
                        codeword = ulsch(ch.Modulation,ch.NLayers,modinfo.G,rv);

                    else
                        % Get the lengths of UCI bits of the overlapped PUCCH
                        uciInfo.OACK = pucch(pucchId).LenACK;
                        uciInfo.OCSI1 = pucch(pucchId).LenCSI1;
                        uciInfo.OCSI2 = pucch(pucchId).LenCSI2;

                        % Get the datasource of UCI bits for the overlapped
                        % PUCCH
                        datasourcePUCCH = hVectorDataSource(pucch(pucchId).DataSource);

                        % Get the proper UCI payload for the specified
                        % configuration
                        if ch.DisableULSCH
                            % Set UL-SCH block size to 0
                            trblksize = 0;
                        end
                        rmInfo = uciRateMatchInfo(trblksize,uciInfo.OACK,uciInfo.OCSI1,uciInfo.OCSI2,ch,modinfo.DMRSSymbolSet);
                        if pucch(pucchId).EnableCoding
                            % Perform UCI encoding based on the
                            % configuration of PUCCH
                            if uciInfo.OACK
                                ack = uciLen(uciInfo.OACK,rmInfo.Gack,ch.Modulation,'HARQ-ACK',datasourcePUCCH,nch);
                                uciInfo.OACK = length(ack);
                            else
                                ack = [];
                            end
                            if uciInfo.OCSI1
                                csi1 = uciLen(uciInfo.OCSI1,rmInfo.Gcsi1,ch.Modulation,'CSI part 1',datasourcePUCCH,nch);
                            else
                                csi1 = [];
                            end
                            if uciInfo.OCSI2
                                csi2 = uciLen(uciInfo.OCSI2,rmInfo.Gcsi2,ch.Modulation,'CSI part 2',datasourcePUCCH,nch);
                            else
                                csi2 = [];
                            end
                            if isfield(rmInfo,'Gackrvd')
                                uciInfo.Gackrvd = rmInfo.Gackrvd;
                            else
                                uciInfo.Gackrvd = [];
                            end

                            % Encode UCI
                            codedACK  = nrUCIEncode(ack,rmInfo.Gack);
                            codedCSI1 = nrUCIEncode(csi1,rmInfo.Gcsi1);
                            codedCSI2 = nrUCIEncode(csi2,rmInfo.Gcsi2);
                        else
                            % If UCI coding is disabled and UL-SCH coding
                            % is enabled, get the coded bits directly from
                            % the data source.
                            if rmInfo.Gack
                                codedACK = datasource.getPacket(rmInfo.Gack);
                            else
                                codedACK = [];
                            end
                            if rmInfo.Gcsi1
                                codedCSI1 = datasource.getPacket(rmInfo.Gcsi1);
                            else
                                codedCSI1 = [];
                            end
                            if rmInfo.GCSI2
                                codedCSI2 = datasource.getPacket(rmInfo.Gcsi2);
                            else
                                codedCSI2 = [];
                            end
                        end

                        % Encode UL-SCH
                        if ~ch.DisableULSCH
                            codedULSCH = ulsch(ch.Modulation,ch.NLayers,modinfo.G,rv);
                        else
                            codedULSCH = [];
                        end

                        % Use a DMRS structure for hMultiplexPUSCH function
                        dmrs = struct;
                        dmrs.SymbolIndices = modinfo.DMRSSymbolSet;

                        % Include the SubscriptIndices in the PUSCH structure
                        % to use it in multiplexer
                        ch.SubscriptIndices = [puschSubcarrierInd puschSymInd];

                        % Multiplex UL-SCH and UCI to create a codeword
                        codeword = hMultiplexPUSCH(codedULSCH,codedACK,codedCSI1,codedCSI2,uciInfo,ch,dmrs);

                        % Display the message
                        disp(['The UCI information is transmitted on PUSCH for slot number ', num2str(allocatedSlots(i)),...
                            ' due to overlap of PUCCH and PUSCH in the bandwidth part ',num2str(ch.BWP),' for RNTI ',num2str(ch.RNTI),'.']);
                    end
                else
                    % UL-SCH processing to create a codeword
                    codeword = ulsch(ch.Modulation,ch.NLayers,modinfo.G,rv);
                end
            else
                % If transport coding is not enabled, get the codeword
                % directly from the data source
                codeword = datasource.getPacket(modinfo.G);
            end

            % PUSCH processing to create the PUSCH symbols
            nID = ch.NID;
            symbols = nrPUSCH(codeword,ch.Modulation,ch.NLayers,nID,ch.RNTI,ch.TransformPrecoding,length(ch.PRBSet),ch.TxScheme,ch.NAntennaPorts,ch.TPMI);

            % Write the PUSCH and DM-RS (precoded) symbols in the slot grid
            % PUSCH
            slotgrid(puschREindices) = symbols*db2mag(ch.Power);
            slotgrid(dmrsREindices) = dmrsSymbols*db2mag(ch.Power+ch.PowerDMRS);

            % Combine PUSCH instance with the rest of the BWP grid
            ResourceElementGrids{ch.BWP}(:,s*symbperslot+(1:symbperslot),1:maxlayers(ch.BWP)) = ResourceElementGrids{ch.BWP}(:,s*symbperslot+(1:symbperslot),1:maxlayers(ch.BWP)) + slotgrid; 

        end

    % End of PUSCH sequence processing
    end

    % Create a new figure to display the plots
    % Map the BWPs into carrier sized PRB grids for display
    if waveconfig.DisplayGrids
        figure;
        for bp = 1:length(ResourceGrids)

            % Mark the unused RE in the overall BWP, relative to the
            % carrier, so that it is easier to see with respect to the
            % complete carrier layout
            bgrid = ResourceGrids{bp};
            cgrid = zeros(carriers((bwp(bp).CarrierIdx)).NRB, size(bgrid,2));
            bgrid(bgrid==0) = 0.15;

            % Write the BWP into the grid representing the carrier
            cgrid(bwp(bp).RBOffset + (1:size(bgrid,1)),:) = bgrid;

            % Plot the PRB BWP grid (relative to the carrier)
            cscaling = 40;
            subplot(length(ResourceGrids),1,bp)
            image(cscaling*cgrid); axis xy; title(sprintf('BWP %d in Carrier (SCS=%dkHz). PUCCH and PUSCH location',bp,bwp(bp).SubcarrierSpacing)); xlabel('Symbols'); ylabel('Carrier RB');

            % Add a channel legend to the first BWP plot (applies to all)
            if bp == 1
                % Extract channel names and color marker levels
                fnames = fieldnames(chplevel);
                cmap = colormap(gcf);
                chpval = struct2cell(chplevel);
                clevels = cscaling*[chpval{:}];
                N = length(clevels);
                L = line(ones(N),ones(N), 'LineWidth',8);                   % Generate lines
                % Index the color map and associated the selected colors with the lines
                set(L,{'color'},mat2cell(cmap( min(1+clevels,length(cmap) ),:),ones(1,N),3));   % Set the colors according to cmap
                % Create legend
                legend(fnames{:});
            end

        end
    end

    % Initialize output variables for the baseband waveform and info structure
    waveform = 0;
    gridset = struct('ResourceGridBWP',{},'ResourceGridInCarrier',{},'Info',{});

    % Establish the maximum carrier SCS configured and the associated k0 subtrahend 
    [maxcarrierscs,maxidx] = max(carrierscs); %#ok<ASGLU>
    k0offset = (carriers(maxidx).RBStart + carriers(maxidx).NRB/2)*12*(carriers(maxidx).SubcarrierSpacing/15);

    % Calculate the maximum OFDM sampling rate used across the configured SCS carriers
    sr = @(x)getfield(hOFDMInfo(struct('NULRB',x.NRB,'SubcarrierSpacing',x.SubcarrierSpacing)),'SamplingRate');
    maxsr = max(arrayfun(sr,carriers));

    % Modulate all the BWP grids and combine all into a single baseband waveform matrix
    for bp = 1:length(ResourceElementGrids)

        % Get the current BWP RE grid
        bgrid = ResourceElementGrids{bp};

        % Get a copy of the SCS carrier config associated with the BWP numerology
        carrier = carriers(bwp(bp).CarrierIdx);
        nrb = carrier.NRB;

        % Check BWP dimensions relative to SCS carrier
        if (bwp(bp).RBOffset+bwp(bp).NRB) > nrb
            error('BWP %d (NRB = %d and RBOffset = %d @ %d kHz SCS) is outside of the SCS carrier bandwidth (NRB = %d).',bp,bwp(bp).NRB,bwp(bp).RBOffset,bwp(bp).SubcarrierSpacing,nrb);
        end

        % Create empty SCS carrier grid and assign in the BWP
        cgrid = zeros(12*nrb,size(bgrid,2),size(bgrid,3));
        cgrid(12*bwp(bp).RBOffset + (1:size(bgrid,1)),:,:) = bgrid;

        % Configure the general settings required by the modulation that are
        % specific to this BWP
        % Use the main input structure for this so that anything other
        % additional modulation specifics settings can be passed through
        % to the modulator
        waveconfig.NULRB = nrb;
        waveconfig.CyclicPrefix = bwp(bp).CyclicPrefix;
        waveconfig.SubcarrierSpacing = bwp(bp).SubcarrierSpacing;
        waveconfig.NSymbol = 0;        % The waveform will always start at the 0th symbol in a slot/subframe/frame

        % Modulate the entire grid
        [bwpwave,minfo] = hOFDMModulate(waveconfig,cgrid);
        %s = length(bwpwave);

        % Apply numerology dependent k0 offset, if required
        k0 = (carrier.RBStart + carrier.NRB/2)*12 - (k0offset/(carrier.SubcarrierSpacing/15));
        if k0~=0
           t = (0:size(bwpwave,1)-1)' / minfo.SamplingRate;
           bwpwave = bwpwave .* exp(1j*2*pi*k0*carrier.SubcarrierSpacing*1e3*t);
        end

        % Add k0 value to the info
        minfo.k0 = k0;

        % Resample to the maximum rate across all carriers, if required
        if minfo.SamplingRate ~= maxsr
            bwpwave = resample(bwpwave,maxsr,minfo.SamplingRate);
        end

        % Combine this BWP with the rest of the waveform
        waveform = waveform + bwpwave;

        % Capture the intermediate grids and modulation info
        gridset(bp).ResourceGridBWP = bgrid;
        gridset(bp).ResourceGridInCarrier = cgrid;
        gridset(bp).Info = minfo;

    end

    % Display *subcarrier* resource grids
    if waveconfig.DisplayGrids

        % Create a new figure to display the subcarrier plots
        figure;
        plotCarriers(waveconfig,gridset);

        % Create a new figure to display the subcarrier plots
        figure;
        % Modulate all the BWP grids and combine all into a single baseband waveform matrix
        for bp = 1:length(ResourceElementGrids)
            % Plot the resource element grid (scaled complex magnitude)
            subplot(length(ResourceElementGrids),1,bp)
            image(40*abs(gridset(bp).ResourceGridInCarrier(:,:,1))); axis xy; 
            title(sprintf('BWP %d in Carrier (SCS=%dkHz)',bp,bwp(bp).SubcarrierSpacing)); xlabel('Symbols'); ylabel('Subcarriers');
        end
    end

% End of main function
end

% Expand 's' with respect to period 'd', up to length 'nsf', optional accounting for the SCS
function sp = expandbyperiod(s,p,nsf,scs)

    if nargin > 3
        % Expand s by period p for ts length
        ts = nsf*1*fix(scs/15);
    else
        ts = nsf;
    end
    % Is the period is empty then the pattern doesn't repeat, so doesn't need extending
    if isempty(p)
        sp = s;
    else
        sp = reshape(s(s<p),[],1)+p*(0:ceil(ts/p)-1);
    end
    sp = reshape(sp(sp < ts),1,[]);            % Trim any excess
end

% Establish the number of symbols per slot from the cyclic prefix
function symbs = symbolsPerSlot(config)

    if isstruct(config)
        config = config.CyclicPrefix;
    end
    cpoptions = {'Normal','Extended'};
    symbs = sum(strcmpi(config,cpoptions) .* [14 12]);

end

% Check a set of named parameter index values against the length of the things 
% that they index
function checkIndex(chname,chset,nch,varargin)
    for p = 1:2:length(varargin)
        paramname = varargin{p};
        paramset = varargin{p+1};
        chindex = chset(nch).(paramname);
        plength = length(paramset);
        if (chindex < 1) || (chindex > plength)
            error('For %s %d, the %s index (%d) must be between 1 and the number of %s defined (%d)',chname,nch,paramname,chindex,paramname,plength);
        end
    end
end

function info = pucchCommonResource(resourceIndex,nSizeBWP)

%   INFO = pucchCommonResource(RESOURCEINDEX,NSIZEBWP) returns
%   the structural information of PUCCH resources for normal cyclic prefix
%   based on the resource index RESOURCEINDEX and size of bandwidth part
%   NSIZEBWP. The structure INFO contains the following fields:
%   PUCCHFormat  - PUCCH format configuration (0 or 1)
%   SymIndex     - Starting symbol index of PUCCH allocation in a slot
%   nPUCCHSym    - Number of OFDM symbols allocated for PUCCH
%   RBOffset     - PRB offset in the BWP
%   StartPRB     - Index of first PRB prior to frequency hopping
%   SecondHopPRB - Index of first PRB after frequency hopping
%   InitialCS    - Initial cyclic shift
%   OCCI         - Orthogonal cover code index. 0 for format 1, [] for
%                  format 0.

    % PUCCH Format number
    if resourceIndex < 3
        format = 0;
        occi = [];
    else
        format = 1;
        occi = 0;
    end

    % Symbol allocation
    if resourceIndex < 3
        symIndex = 12;
        nPUCCHSym = 2;
    elseif resourceIndex < 7
        symIndex = 10;
        nPUCCHSym = 4;
    elseif resourceIndex < 11
        symIndex = 4;
        nPUCCHSym = 10;
    else
        symIndex = 0;
        nPUCCHSym = 14;
    end

    % Initial cyclic shift
    csIndexesTable = {{0 3},{0 4 8},{0 4 8},{0 6},{0 3 6 9},{0 3 6 9},...
                      {0 3 6 9},{0 6},{0 3 6 9},{0 3 6 9},{0 3 6 9},{0 6},...
                      {0 3 6 9},{0 3 6 9},{0 3 6 9},{0 3 6 9}};
    nCSList = arrayfun(@(x)(length(csIndexesTable{x})), 1:length(csIndexesTable), 'UniformOutput', false);
    nCS = nCSList{resourceIndex+1};
    initialCS = csIndexesTable{resourceIndex+1}{mod(mod(resourceIndex,8),nCS)+1};

    % Resource block index for each hop
    rbOffsetList = [0 0 3 0 0 2 4 0 0 2 4 0 0 2 4 floor(nSizeBWP/4)];
    rbOffset = rbOffsetList(resourceIndex+1);
    if resourceIndex < 8
        startPRB = rbOffset + floor(resourceIndex/nCS);
        secondHopPRB = nSizeBWP-1-rbOffset-floor(resourceIndex/nCS);
    else
        startPRB = nSizeBWP-1-rbOffset-floor((resourceIndex-8)/nCS);
        secondHopPRB = rbOffset + floor((resourceIndex-8)/nCS);
    end

    % Combine information into a structure
    info.PUCCHFormat = format;
    info.StartSymbol = symIndex-1; % 0-based
    info.NrOfSymbols = nPUCCHSym;
    info.RBOffset = rbOffset;
    info.GroupHopping = 'enable';
    info.IntraSlotFreqHopping = 'enabled';
    info.StartPRB = startPRB;
    info.SecondHopPRB = secondHopPRB;
    info.InitialCS = initialCS;
    info.OCCI = occi;
end

function cas = getControlAllocatedSlots(pucch,bwp,NumSubframes)
    % Allocated slots for control information (PUCCH)
    cas = cell(length(pucch),1);
    for i = 1:length(pucch)
        ch = pucch(i);
        if ch.Enable
            if ch.NrOfSlots > 1 ...
                        && (ch.PUCCHFormat == 1 || ch.PUCCHFormat == 3 || ch.PUCCHFormat == 4)
                allocatedSlots = expandbyperiod(unique(ch.AllocatedSlots + (0:ch.NrOfSlots-1)')',ch.AllocatedPeriod,NumSubframes,bwp(ch.BWP).SubcarrierSpacing);
            else
                allocatedSlots = expandbyperiod(ch.AllocatedSlots,ch.AllocatedPeriod,NumSubframes,bwp(ch.BWP).SubcarrierSpacing);
            end
            cas{i} = allocatedSlots;
        end
    end
end

function uas = getULSCHAllocatedSlots(pusch,bwp,NumSubframes)
    % Allocated slots for UL-SCH information (PUSCH)
    uas = cell(length(pusch),1);
    for i = 1:length(pusch)
        ch = pusch(i);
        if ch.Enable
            uas{i} = expandbyperiod(ch.AllocatedSlots,ch.AllocatedPeriod,NumSubframes,bwp(ch.BWP).SubcarrierSpacing);
        end
    end
end

function [overlapSlots,rnti] = getOverlapSlots(pucch,pusch,bwp,NumSubframes)

    % Overlap slots of PUCCH and PUSCH in a BWP
    rnti = cell(length(bwp),1);
    for i = 1:length(bwp)
        % PUCCH(s) index related to BWP identity 'i'
        cIndex = false(1,length(pucch));
        cRNTI = -1*ones(1,length(pucch));
        count = 0;
        for ipucch = 1:length(pucch)
            ch = pucch(ipucch);
            if ch.Enable
                cIndex(ipucch) = (ch.BWP == i);
                if cIndex(ipucch)
                    if ch.RNTI < 0
                        error('For PUCCH %d in BWP %d, the RNTI (%d) must be in range 0 to 65535.',ipucch,i,ch.RNTI);
                    end
                    cRNTI(ipucch) = ch.RNTI;
                    count = count+1;
                end
            end
        end
        if count > nnz(unique(cRNTI)>=0)
            error('Each PUCCH in BWP %d, must have unqiue RNTI.',i);
        end
        % PUSCH(s) index related to BWP identity 'i'
        uIndex = false(1,length(pusch));
        uRNTI = -1*ones(1,length(pucch));
        count = 0;
        for ipusch = 1:length(pusch)
            ch = pusch(ipusch);
            if ch.Enable
                uIndex(ipusch) = (ch.BWP == i);
                if uIndex(ipusch)
                    if ch.RNTI < 0
                        error('For PUSCH %d in BWP %d, the RNTI (%d) must be in range 0 to 65535.',ipusch,i,ch.RNTI);
                    end
                    uRNTI(ipusch) = ch.RNTI;
                    count = count+1;
                end
            end
        end
        if count > nnz(unique(uRNTI)>=0)
            error('Each PUSCH in BWP %d, must have unqiue RNTI.',i);
        end
        rnti{i} = union(cRNTI,uRNTI);

        % Get the overlapping slots
        for j = 1:length(rnti{i})
            pucchIdx = (rnti{i}(j) == cRNTI);
            puschIdx = (rnti{i}(j) == uRNTI);

            if ~(any(pucchIdx) && any(puschIdx)) || (rnti{i}(j) == -1)
                overlapSlots{i,j} = [];    %#ok<AGROW>
            else
                cch = pucch(pucchIdx);
                if cch.NrOfSlots > 1 ...
                        && (cch.PUCCHFormat == 1 || cch.PUCCHFormat == 3 || cch.PUCCHFormat == 4)
                    cSlots = expandbyperiod(unique(cch.AllocatedSlots + (0:cch.NrOfSlots-1)')',cch.AllocatedPeriod,NumSubframes,bwp(cch.BWP).SubcarrierSpacing);
                else
                    cSlots = expandbyperiod(cch.AllocatedSlots,cch.AllocatedPeriod,NumSubframes,bwp(cch.BWP).SubcarrierSpacing);
                end
                sch = pusch(puschIdx);
                uSlots = expandbyperiod(sch.AllocatedSlots,sch.AllocatedPeriod,NumSubframes,bwp(sch.BWP).SubcarrierSpacing);
                overlapSlots{i,j} = intersect(cSlots,uSlots);   %#ok<AGROW>
            end
        end
    end
end

function rmInfo = uciRateMatchInfo(oULSCH,oACK,oCSI1,oCSI2,pusch,dmrsSym)
%uciRateMatchInfo UCI rate matching lengths information
%   RMINFO = uciRateMatchInfo(OULSCH,OACK,OCSI1,OCSI2,PUSCH,DMRSSYM,DMRSRE)
%   returns the lengths of UCI information (HARQ-ACK, CSI part 1, CSI part
%   2) that has to be rate matched when multiplexed on PUSCH, as per TS
%   38.212 Section 6.3.2.4, provided the following inputs:
%   OULSCH  - Number of UL-SCH information bits
%   OACK    - Number of HARQ-ACK information bits
%   OCSI1   - Number of CSI part 1 bits
%   OCSI2   - Number of CSI part 2 bits
%   PUSCH   - PUSCH Structure with the following fieds:
%             AllocatedSymbols   - The OFDM symbol indices allocated for
%                                  PUSCH transmission in a slot (0-based)
%             AllocatedPRB       - The resource blocks allocated for
%                                  PUSCH transmission in a slot (0-based)
%             Modulation         - Modulation scheme. It is one of the set
%                              {'pi/2-BPSK','QPSK','16QAM','64QAM','256QAM'}
%             NLayers            - Number of layers (1...4)
%             TransformPrecoding - Set the transform precoding flag. It can
%                                  be either 0 or 1.
%             TargetCodeRate     - Code rate of PUSCH
%             BetaOffsetACK      - Power factor of HARQ-ACK
%             BetaOffsetCSI1     - Power factor of CSI part 1
%             BetaOffsetCSI2     - Power factor of CSI part 2
%             ScalingFactor      - Scaling factor. It is provided by
%                                  higher-layer parameter scaling. The
%                                  value is one of the set {0.5, 0.65
%                                  ,0.8, 1}
%   DMRSSYM - DM-RS symbol indices on PUSCH (0-based)

    info = nrULSCHInfo(oULSCH,pusch.TargetCodeRate);
    C = info.C; % Number of code blocks for UL-SCH
    k = info.K; % Code block size of each code block
    nlayers = pusch.NLayers;

    qm = nr5g.internal.getQm(pusch.Modulation); % 'pi/2-BPSK','QPSK','16QAM','64QAM','256QAM'

    % CBGTI is not supported yet, so all the code blocks of UL-SCH are
    % scheduled for PUSCH
    a = ones(C,1);

    nPUSCHsymall = length(pusch.AllocatedSymbols);
    msc = zeros(nPUSCHsymall,1);

    puschSubcarriers = 12*length(pusch.AllocatedPRB);
    puschSymbols = setdiff(pusch.AllocatedSymbols-pusch.AllocatedSymbols(1),dmrsSym-pusch.AllocatedSymbols(1));
    puschSymbols = puschSymbols+1; % 1-based
    dmrsSym = dmrsSym+1-pusch.AllocatedSymbols(1); % 1-based
    msc(puschSymbols) = puschSubcarriers; % Considering no PT-RS
    tcr = pusch.TargetCodeRate;

    if ~isempty(dmrsSym)
        l0 = puschSymbols(find((dmrsSym(1)<puschSymbols),1)); % 1-based
    else
        l0 = puschSymbols(1);
    end
    s1 = sum(msc);
    s2 = sum(msc(l0:end));

    if oACK < 2
        % Get the reserved bits when oACK < 2
        oACKrvd = 2;
    else
        oACKrvd = 0;
    end

    if oACK
        Lack = getCRC(oACK);
        if oULSCH
            qDashACK = min(ceil((oACK+Lack)*pusch.BetaOffsetACK*s1/sum(a*k)),...
            ceil(pusch.ScalingFactor*s2));
        else
            qDashACK = min(ceil((oACK+Lack)*pusch.BetaOffsetACK/(tcr*qm)),...
                ceil(pusch.ScalingFactor*s2));
        end
        EuciACK = nlayers*qDashACK*qm;
    else
        qDashACK = 0;
        EuciACK = 0;
    end

    if oACKrvd
        Lackrvd = getCRC(oACKrvd);
        if oULSCH
            qDashACKrvd = min(ceil((oACKrvd+Lackrvd)*pusch.BetaOffsetACK*s1/sum(a*k)),...
            ceil(pusch.ScalingFactor*s2));
        else
            qDashACKrvd = min(ceil((oACKrvd+Lackrvd)*pusch.BetaOffsetACK/(tcr*qm)),...
                ceil(pusch.ScalingFactor*s2));
        end
        EuciACKrvd = nlayers*qDashACKrvd*qm;
    end

    if oCSI1
        Lcsi1 = getCRC(oCSI1);
        if oACKrvd
            qDashACKCSI1 = qDashACKrvd;
        else
            qDashACKCSI1 = qDashACK;
        end
        if oULSCH
            qDashCSI1 = min(ceil((oCSI1+Lcsi1)*pusch.BetaOffsetCSI1*s1/sum(a*k)),...
            ceil(pusch.ScalingFactor*s1)-qDashACKCSI1);
        else
            if oCSI2
                qDashCSI1 = min(ceil((oCSI1+Lcsi1)*pusch.BetaOffsetCSI1/(tcr*qm)),...
               s1-qDashACKCSI1);
            else
                qDashCSI1 = s1-qDashACKCSI1;
            end
        end
        EuciCSI = nlayers*qDashCSI1*qm;
    else
        qDashCSI1 = 0;
        EuciCSI = 0;
    end

    if oCSI2
        Lcsi2 = getCRC(oCSI2);
        qDashACKCSI2 = qDashACK;
        if oACK <= 2
            qDashACKCSI2 = 0;
        end
        if oULSCH
            qDashCSI2 = min(ceil((oCSI2+Lcsi2)*pusch.BetaOffsetCSI2*s1/sum(a*k)),...
            ceil(pusch.ScalingFactor*s1)-qDashACKCSI2-qDashCSI1);
        else
            qDashCSI2 = s1-qDashACKCSI2-qDashCSI1;
        end
        EuciCSI2 = nlayers*qDashCSI2*qm;
    else
        qDashCSI2 = 0;
        EuciCSI2 = 0;
    end

    if oACKrvd
        rmInfo.Gackrvd = EuciACKrvd;
    end
    rmInfo.Gack  = EuciACK;
    rmInfo.Gcsi1 = EuciCSI;
    rmInfo.Gcsi2 = EuciCSI2;
    rmInfo.Nack  = qDashACK;
    rmInfo.Ncsi1 = qDashCSI1;
    rmInfo.Ncsi2 = qDashCSI2;

end

function L = getCRC(oUCI,fl)
% CRC bits for UCI information for input length oUCI (default).
% Also returns the number of CRC bits added when fl is 1, oUCI is treated
% as the rate matched length.
    if oUCI > 19
        L = 11;
    elseif oUCI > 11
        L = 6;
    else
        L = 0;
    end
    if nargin == 2 && fl
        if oUCI > 25
            L = 11;
        elseif oUCI > 17
            L = 6;
        else
            L = 0;
        end
    end
end

function prbIndices = prbValues(resInfo)

    % Check with intra-slot frequency hopping
    if (strcmpi(resInfo.IntraSlotFreqHopping,'enabled') && (isempty(resInfo.SecondHopPRB) || ~isfield(resInfo,'SecondHopPRB')))...
            || strcmpi(resInfo.IntraSlotFreqHopping,'disabled')
        resInfo.SecondHopPRB = resInfo.StartPRB;
    end

    % Initialize number of resource blocks
    nrOfRB = 1;
    if resInfo.PUCCHFormat == 2 || resInfo.PUCCHFormat == 3
        nrOfRB = resInfo.NrOfRB;
    end

    prbIndices = [resInfo.StartPRB resInfo.SecondHopPRB]+(0:nrOfRB-1)';
end

function v = uciLen(i,r,m,t,d,n)
%  Returns the UCI packet v, based on the input length i, rate match
%  length r, modulation scheme m, the type t and the data source d, when
%  UCI information is to be multiplexed on PUSCH n.

    if (i == 1 && strcmpi(m,'pi/2-BPSK')) ...
        && (i == r)
        v = d.getPacket(i);
    else
        if i + getCRC(i) >= r
            mUCI = r-getCRC(r,1)-1;
            if mUCI > 0
                warning('For the specified configuration, the number of %s bits (%d) is reduced to %d bits to transmit on PUSCH %d',...
                    t,i,mUCI,n);
                v = d.getPacket(mUCI);
            else
                warning('The %s is not transmitted on the specified PUSCH %d configuration',t,n);
                v = [];
            end
        else
            v = d.getPacket(i);
        end
    end
end

% Plot the SCS carriers
function plotCarriers(waveconfig,gridset)

    if (isfield(waveconfig,'ChannelBandwidth'))
        cbw = waveconfig.ChannelBandwidth;
    else
        cbw = [];
    end

    legends = {};
    hold on;
    ylimits = [-numel(gridset) numel(gridset)*2.5];
    if (~isempty(cbw))
        plot([-cbw/2 -cbw/2],ylimits,'k--');
        legends = [legends 'Channel edges'];
    end
    xlabel('Frequency (MHz)');

    carriers = waveconfig.Carriers;
    [~,ix] = sort([carriers.SubcarrierSpacing]);
    carriers = carriers(ix);

    scsString = mat2str([carriers.SubcarrierSpacing]);
    nrbString = mat2str([carriers.NRB]);
    if (~isempty(cbw))
        titleStr = [num2str(cbw) 'MHz channel, '];
    else
        titleStr = [];
    end
    title([titleStr ' NRB=' nrbString ', SCS=' scsString 'kHz']);

    blue = [0 0.447 0.741];
    red = [0.850 0.325 0.098];
    orange = [0.929 0.694 0.125];
    green = [0.466 0.674 0.188];

    bwpinfo = [gridset.Info];
    bwpscs = [bwpinfo.SubcarrierSpacing];

    for i = numel(carriers):-1:1

        NRB = carriers(i).NRB;
        SCS = carriers(i).SubcarrierSpacing;
        RBStart = carriers(i).RBStart;

        bwpidx = find(SCS == bwpscs,1);
        k0 = bwpinfo(bwpidx).k0;

        if (~isempty(cbw) && isfield(waveconfig,'FrequencyRange'))
            guardband = getGuardband(waveconfig.FrequencyRange,cbw,SCS);
        else
            guardband = [];
        end

        SCS = SCS / 1e3; % SCS now in MHz

        ypos = numel(carriers) - i;

        for rb = 0:(NRB-1)

            f = ((rb*12) + k0 - (NRB*12/2)) * SCS;
            r = rectangle('Position',[f ypos 12*SCS 1]);
            r.FaceColor = orange;

            if (rb==0)
                point_a = f - (RBStart*12*SCS);
            end

        end

        if (~isempty(guardband))
            plot(ones(1,2) * (-cbw/2 + guardband), ypos + [0 1],'Color',red,'LineWidth',2);
            legends = [legends 'Guardband edges']; %#ok<AGROW>
        end
        plot(ones(1,2) * point_a, ypos + [-0.2 1.2],'-..','Color',green,'LineWidth',2);
        legends = [legends 'Point A']; %#ok<AGROW>
        plot(ones(1,2) * k0 * SCS,ypos + [0.1 0.9],'Color',blue,'LineWidth',2);
        legends = [legends 'k_0']; %#ok<AGROW>

        if (i==numel(carriers))
            p = plot(ones(1,2) * k0 * SCS,ylimits,'k:');
            legends = [legends 'f_0']; %#ok<AGROW>
            p.Parent.YTick = [];
            lg = legend(legends);
            lg.AutoUpdate = 'off';
        end

        if (~isempty(guardband))
            plot(ones(1,2) * (cbw/2 - guardband), ypos + [0 1],'Color',red,'LineWidth',2);
        end

    end

    if (~isempty(cbw))
        plot([cbw/2 cbw/2],ylimits,'k--');
        p.Parent.XLim = [-cbw/2*1.1 cbw/2*1.1];
    end
    p.Parent.YLim = ylimits;

end

% Section 5.3.3, TS 38.101-1 (FR1), TS 38.101-2 (FR2)
% Minimum guardband and transmission bandwidth configuration
function guardband = getGuardband(fr,cbw,scs)

    % Table 5.3.3-1: Minimum guardband [kHz] (FR1) (TS 38.101-1)
    cbwFR1    = [    5     10    15     20     25     30     40     50     60     80     90    100];
    guardsFR1 = [242.5  312.5 382.5  452.5  522.5  592.5  552.5  692.5    NaN    NaN    NaN    NaN; ...
                 505.0  665.0 645.0  805.0  785.0  945.0  905.0 1045.0  825.0  925.0  885.0  845.0; ...
                   NaN 1010.0 990.0 1330.0 1310.0 1290.0 1610.0 1570.0 1530.0 1450.0 1410.0 1370.0];
    scsFR1 = [15 30 60].';

    % Table 5.3.3-1: Minimum guardband [kHz] (FR2) (TS 38.101-2)
    cbwFR2    = [  50  100  200  400];
    guardsFR2 = [1210 2450 4930  NaN; ...
                 1900 2420 4900 9860];
    scsFR2 = [60 120].';

    % Return value in MHz
    if (strcmpi(fr,'FR1'))
        guardband = guardsFR1(scsFR1==scs,cbwFR1==cbw) / 1e3;
    else % FR2
        guardband = guardsFR2(scsFR2==scs,cbwFR2==cbw) / 1e3;
    end

end
