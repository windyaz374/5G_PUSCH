%% 5G NR Uplink Carrier Waveform Generation
% This example implements a 5G NR uplink carrier waveform generator using
% 5G Toolbox(TM).

% Copyright 2019 The MathWorks, Inc.

%% Introduction
% This example shows how to parameterize and generate a 5G New Radio (NR)
% uplink waveform. The following channels and signals are generated
%
% * PUSCH and its associated DM-RS
% * PUCCH and its associated DM-RS
%
% This example supports the parameterization and generation of multiple
% bandwidth parts (BWP). Multiple instances of the PUSCH and PUCCH channels
% can be generated over the different BWPs. The example allows to configure
% PUCCH and PUSCH for a specific UE categorized by RNTI and transmits only
% PUSCH for that specific RNTI when both PUCCH and PUSCH overlap in a slot.

%% Waveform and Carrier Configuration
% This section sets the subcarrier spacing (SCS) specific carrier
% bandwidths in resource blocks, the physical layer cell identity NCellID,
% and the length of the generated waveform in subframes. You can visualize
% the generated resource grids by setting the |DisplayGrids| field to 1.
% The channel bandwidth and frequency range parameters are used to display
% the associated minimum guardbands on a schematic diagram of the SCS
% carrier alignment. The schematic diagram is displayed in one of the
% output plots of the example.

waveconfig = [];
waveconfig.NCellID = 0;            % Cell identity
waveconfig.ChannelBandwidth = 50;  % Channel bandwidth (MHz)
waveconfig.FrequencyRange = 'FR1'; % 'FR1' or 'FR2'
waveconfig.NumSubframes = 10;      % Number of 1ms subframes in generated waveform
                                   % (1,2,4,8 slots per 1ms subframe,
                                   % depending on SCS)
waveconfig.DisplayGrids = 1;       % Display the resource grids after signal generation

% Define a set of SCS specific carriers, using the maximum sizes for a 50
% MHz NR channel. See TS 38.101-1 for more information on defined
% bandwidths
carriers = [];
carriers(1).SubcarrierSpacing = 15;
carriers(1).NRB = 270;
carriers(1).RBStart = 0;

carriers(2).SubcarrierSpacing = 30;
carriers(2).NRB = 133;
carriers(2).RBStart = 1;

%% Bandwidth Parts
% A BWP is formed by a set of contiguous resources sharing a numerology on
% a given SCS specific carrier. This example supports the use of multiple
% BWPs using a struct array. Each entry in the array represents a BWP. For
% each BWP you can specify the subcarrier spacing (SCS), the cyclic prefix
% (CP) length and the bandwidth. The |SubcarrierSpacing| parameter maps the
% BWP to one of the SCS specific carriers defined earlier. The |RBOffset|
% parameter controls the location of the BWP in the carrier. This is
% expressed in terms of the BWP numerology. Different BWPs can overlap with
% each other.
%
% <<../bwp.png>>

% Bandwidth parts configurations
bwp = [];

bwp(1).SubcarrierSpacing = 15;              % BWP1 Subcarrier Spacing
bwp(1).CyclicPrefix = 'Normal';             % BWP1 cyclic prefix
bwp(1).NRB = 25;                            % Size of BWP1
bwp(1).RBOffset = 10;                       % Position of BWP1 in carrier

bwp(2).SubcarrierSpacing = 30;              % BWP2 Subcarrier Spacing
bwp(2).CyclicPrefix = 'Normal';             % BWP2 cyclic prefix
bwp(2).NRB = 51;                            % Size of BWP2
bwp(2).RBOffset = 40;                       % Position of BWP2 in carrier

%% PUCCH Instances Configuration
% This section specifies the parameters for the set of PUCCH instances in
% the waveform. Each element in the structure array defines a PUCCH
% sequence instance. The following parameters can be set:
%
% * Enable/disable the PUCCH sequence
% * Specify the BWP carrying the PUCCH
% * PUCCH instance power in dB
% * Slots within a period used for PUCCH
% * Periodicity of the allocation. Use empty to indicate no repetition
% * DM-RS power boosting in dB

pucch = [];
pucch(1).Enable = 1;                        % Enable PUCCH sequence 
pucch(1).BWP = 1;                           % Bandwidth part
pucch(1).Power = 0;                         % Power scaling in dB
pucch(1).AllocatedSlots = [3 4];            % Allocated slots within a period
pucch(1).AllocatedPeriod = 6;               % Allocation slot period (empty implies no repetition)
pucch(1).PowerDMRS = 1;                     % Additional power boosting in dB

%%
% *PUCCH Resource Configuration*
%
% This section specifies the PUCCH sequence resource related parameters.
% The parameters can be categorized into the following sections:
%
% * Enable/Disable the PUCCH dedicated resource. If this is disabled, it
% uses common resource as per TS 38.213 Section 9.2.1
% * Provide the resource index value (0...15), when dedicated resource is
% disabled and the cyclic prefix of BWP transmitting PUCCH is normal. In
% this case, the resource and format parameters for the PUCCH transmission
% are filled up directly based on the resource index. All the other
% parameters that are provided for resource and format configurations are
% not considered.
%%
% When the dedicated resource is enabled or when the dedicated resource is
% disabled with the cyclic prefix of BWP transmitting PUCCH is extended,
% the following resource parameters need to be provided:
%
% * Specify the index of first PRB prior to frequency hopping or for no
% frequency hopping within the BWP
% * Specify the index of first PRB after frequency hopping within the BWP
% * Intra-slot frequency hopping configuration ('enabled','disabled')
% * Group hopping configuration ('neither','enable','disable')
%
%%
% and the following format specific parameters need to be provided:
%
% * PUCCH format configuration in the resource (0...4)
% * Starting symbol index allocated for PUCCH transmission
% * Number of OFDM symbols allocated for PUCCH transmission. For PUCCH
% formats 1, 3 and 4, the number of OFDM symbols allocated are in range 4
% to 14, and for formats 0 and 2, it is either 1 or 2
% * Initial cyclic shift for formats 0 and 1. The value is in range 0 to 11
% * Modulation scheme for formats 3 and 4 ('QPSK','pi/2-BPSK')
% * Number of resource blocks allocated for format 2 and 3. The nominal
% value is one of the set {1,2,3,4,5,6,8,9,10,12,15,16}
% * Spreading factor for format 4. The value is either 2 or 4
% * Orthogonal cover code index for formats 1 and 4. For format 1, the
% value is in range 0 to 6. For format 4, the value is less than spreading
% factor and greater than or equal to 0
% * Indicate the presence of additional DM-RS for formats 3 and 4. The
% value is either 0 or 1
%%
% Scrambling identities to be used for different formats
%
% * RNTI for formats 2/3/4. It is used for sequence generation. It is in
% range 0 to 65535
% * Scrambling identity (NID) for PUCCH formats 2/3/4. It is in range 0 to
% 1023. Use empty ([]) to use physical layer cell identity. It is used in
% sequence generation. This parameter is provided by higher-layer parameter
% |_dataScramblingIdentityPUSCH_|
% * PUCCH hopping identity for formats 0/1/3/4. Use empty ([]) to use
% physical layer cell identity. The value is used in sequence generation
% for format 0, both sequence and DM-RS generation for format 1 and only
% for DM-RS generation for formats 3 and 4
% * DM-RS scrambling NID for PUCCH format 2. It is in range 0 to 65535. Use
% empty ([]) to use physical layer cell identity
%%
% Irrespective of dedicated resource configuration, the following
% parameters are to be provided for slot repetitions:
%
% * Specify the number of slot repetitions for formats 1,3,4 (2 or 4 or 8).
% For no slot repetition, the value can be specified as 1
% * Specify the inter-slot frequency hopping for formats 1,3,4
% ('enabled','disabled'). If this is enabled and the number of slot
% repetitions is more than one, then intra-slot frequency hopping is
% disabled
% * Specify the maximum code rate. The nominal value is one of the set
% {0.08, 0.15, 0.25, 0.35, 0.45, 0.6, 0.8}

% Dedicated resource parameters
pucch(1).DedicatedResource = 1;             % Enable/disable the dedicated resource configuration (1/0)
% Provide the resource index value when dedicated resource is disabled. The
% PUCCH resource is configured based on the resource index value, as per
% the table 9.2.1-1 of Section 9.2.1, TS 38.213.
pucch(1).ResourceIndex = 0;                 % Resource index for PUCCH dedicated resource (0...15)

% When dedicated resource is enabled or when the dedicated resource is
% disabled with the cyclic prefix of BWP transmitting PUCCH is extended,
% the resource index value is ignored and the parameters specified below
% for the resource and format configurations are considered.

% Resource parameters
pucch(1).StartPRB = 0;                      % Index of first PRB prior to frequency hopping or for no frequency hopping
pucch(1).SecondHopPRB = 1;                  % Index of first PRB after frequency hopping
pucch(1).IntraSlotFreqHopping = 'enabled';  % Indication for intra-slot frequency hopping ('enabled','disabled')
pucch(1).GroupHopping = 'enable';           % Group hopping configuration ('enable','disable','neither') 

% Format specific parameters
pucch(1).PUCCHFormat = 3;                   % PUCCH format 0/1/2/3/4
pucch(1).StartSymbol = 3;                   % Starting symbol index
pucch(1).NrOfSymbols = 11;                  % Number of OFDM symbols allocated for PUCCH
pucch(1).InitialCS = 3;                     % Initial cyclic shift for format 0 and 1
pucch(1).OCCI = 0;                          % Orthogonal cover code index for format 1 and 4
pucch(1).Modulation = 'QPSK';               % Modulation for format 3/4 ('pi/2-BPSK','QPSK')
pucch(1).NrOfRB = 9;                        % Number of resource blocks for format 2/3
pucch(1).SpreadingFactor = 4;               % Spreading factor for format 4, value is either 2 or 4
pucch(1).AdditionalDMRS = 1;                % Additional DM-RS (0/1) for format 3/4

% Scrambling identities of PUCCH and PUCCH DM-RS
pucch(1).RNTI = 0;                          % RNTI (0...65535) for formats 2/3/4
pucch(1).NID = 1;                           % PUCCH scrambling identity (0...1023) for formats 2/3/4
pucch(1).HoppingId = 1;                     % PUCCH hopping identity (0...1023) for formats 0/1/3/4
pucch(1).NIDDMRS = 1;                       % DM-RS scrambling identity (0...65535) for PUCCH format 2

% Multi-slot configuration parameters
pucch(1).NrOfSlots = 1;                     % Number of slots for PUCCH repetition (1/2/4/8). One for no repetition
pucch(1).InterSlotFreqHopping = 'disabled'; % Indication for inter-slot frequency hopping ('enabled','disabled'), used in PUCCH repetition

% Code rate - This parameter is used when there is multiplexing of UCI part
% 1 (HARQ-ACK, SR, CSI part 1) and UCI part 2 (CSI part 2) to get the rate
% matching lengths of each UCI part
pucch(1).MaxCodeRate = 0.15;                % Maximum code rate (0.08, 0.15, 0.25, 0.35, 0.45, 0.6, 0.8)

%%
% *UCI payload configuration*
%
% Configure the UCI payload based on the format configuration
%
% * Enable or disable the UCI coding for formats 2/3/4
% * Number of HARQ-ACK bits. For formats 0 and 1, value can be at most 2.
% Set the value to 0, for no HARQ-ACK transmission
% * Number of SR bits. For formats 0 and 1, value can be at most 1. Set the
% value to 0, for no SR transmission
% * Number of CSI part 1 bits for formats 2/3/4. Set value to 0, for no CSI
% part 1 transmission
% * Number of CSI part 2 bits for formats 3/4. Set value to 0, for no CSI
% part 2 transmission. The value is ignored when there are no CSI part 1
% bits
%%
% Note that the generator in the example transmits UCI information on PUSCH
% whenever there is a overlap between PUCCH and PUSCH for a specific RNTI
% in a BWP. The parameters to be configured for UCI transmission on PUSCH
% are provided in the section UCI on PUSCH. It requires the lengths of UCI
% and UL-SCH to be transmitted on PUSCH.

pucch(1).EnableCoding = 1;                  % Enable UCI coding
pucch(1).LenACK = 5;                        % Number of HARQ-ACK bits
pucch(1).LenSR = 5;                         % Number of SR bits
pucch(1).LenCSI1 = 10;                      % Number of CSI part 1 bits (for formats 2/3/4)
pucch(1).LenCSI2 = 10;                      % Number of CSI part 2 bits (for formats 3/4)

pucch(1).DataSource = 'PN9';                % UCI data source

% UCI message data source. You can use one of the following standard PN
% sequences: 'PN9-ITU', 'PN9', 'PN11', 'PN15', 'PN23'. The seed for the
% generator can be specified using a cell array in the form |{'PN9',seed}|.
% If no seed is specified, the generator is initialized with all ones
%%
% *Specifying Multiple PUCCH Instances*
%
% A second PUCCH sequence instance is specified next using the second BWP.

% PUCCH sequence instance specific to second BWP
pucch(2) = pucch(1);
pucch(2).BWP = 2;
pucch(2).StartSymbol = 10;
pucch(2).NrOfSymbols = 2;
pucch(2).PUCCHFormat = 2;
pucch(2).AllocatedSlots = 0:2;
pucch(2).AllocatedPeriod = [];
pucch(2).RNTI = 10;

%% PUSCH Instances Configuration
% This section specifies the set of PUSCH instances in the waveform using a
% struct array. This example defines two PUSCH sequence instances.
%
% *General Parameters*
%
% The following parameters are set for each instance:
%
% * Enable/disable this PUSCH sequence
% * Specify the BWP this PUSCH maps to. The PUSCH will use the SCS
% specified for this BWP
% * Power scaling in dB
% * Enable/disable the UL-SCH transport coding
% * Scrambling identity (NID) for PUSCH bits. It is in range 0 to 1023. Use
% empty ([]) to use physical layer cell identity
% * RNTI
% * Transform precoding (0,1). The value of 1, enables the transform
% precoding and the resultant waveform is DFT-s-OFDM. When the value is 0,
% the resultant waveform is CP-OFDM
% * Target code rate used to calculate the transport block sizes.
% * Overhead parameter. It is used to calculate the length of transport
% block size. It is one of the set {0, 6, 12, 18}
% * Transmission scheme ('codebook','nonCodebook'). When the transmission
% scheme is 'codebook', the MIMO precoding is enabled and a precoding
% matrix is selected based on the number of layers, number of antenna ports
% and the transmitted precoding matrix indicator. When the transmission is
% set to 'nonCodebook', an identity matrix is used, leading to no MIMO
% precoding
% * Modulation scheme ('pi/2-BPSK', 'QPSK', '16QAM', '64QAM', '256QAM').
% Nominally, the modulation scheme 'pi/2-BPSK' is used when transform
% precoding is enabled
% * Number of layers (1...4). The number of layers is restricted to a
% maximum of 4 in uplink as there is only one code word transmission.
% Nominally, the number of layers is set to 1 when transform precoding is
% enabled
% * Number of antenna ports (1,2,4). It is used when codebook transmission
% is enabled. The number of antenna ports must be greater than or equal to
% number of layers
% * Transmitted precoding matrix indicator (0...27). It depends on the
% number of layers and the number of antenna ports
% * Redundancy version (RV) sequence
% * Intra-slot frequency hopping ('enabled','disabled')
% * Resource block offset for second hop. It is used when frequency
% (Intra-slot/Inter-slot) hopping is enabled
% * Inter-slot frequency hopping ('enabled','disabled'). If this is
% enabled, intra-slot frequency hopping is disabled, the starting position
% of resource block in the allocated PRB of PUSCH in the bandwidth part
% depends on the whether the slot is even-numbered or odd-numbered
% * Transport block data source. You can use one of the following standard
% PN sequences: 'PN9-ITU', 'PN9', 'PN11', 'PN15', 'PN23'. The seed for the
% generator can be specified using a cell array in the form |{'PN9',
% seed}|. If no seed is specified, the generator is initialized with all
% ones

pusch = [];
pusch(1).Enable = 1;                        % Enable PUSCH config
pusch(1).BWP = 1;                           % Bandwidth part
pusch(1).Power = 0;                         % Power scaling in dB
pusch(1).EnableCoding = 1;                  % Enable the UL-SCH transport coding
pusch(1).NID = 1;                           % Scrambling for data part (0...1023)
pusch(1).RNTI = 0;                          % RNTI
pusch(1).TransformPrecoding = 0;            % Transform precoding flag (0 or 1)
pusch(1).TargetCodeRate = 0.47;             % Code rate used to calculate transport block sizes
pusch(1).Xoh_PUSCH = 0;                     % Overhead. It is one of the set {0,6,12,18}

% Transmission settings
pusch(1).TxScheme = 'nonCodebook';             % Transmission scheme ('codebook','nonCodebook')
pusch(1).Modulation = 'QPSK';               % 'pi/2-BPSK','QPSK','16QAM','64QAM','256QAM'
pusch(1).NLayers = 1;                       % Number of PUSCH layers (1...4)
pusch(1).NAntennaPorts = 1;                 % Number of antenna ports (1,2,4). It must not be less than number of layers
pusch(1).TPMI = 0;                          % Transmitted precoding matrix indicator (0...27)
pusch(1).RVSequence = [0 2 3 1];            % RV sequence to be applied cyclically across the PUSCH allocation sequence
pusch(1).IntraSlotFreqHopping = 'disabled'; % Intra-slot frequency hopping ('enabled','disabled')
pusch(1).RBOffset = 10;                     % Resource block offset for second hop

% Multi-slot transmission
pusch(1).InterSlotFreqHopping = 'enabled';  % Inter-slot frequency hopping ('enabled','disabled')

% Data source
pusch(1).DataSource = 'PN9';                % Transport block data source

%%
% *Allocation*
%
% You can set the following parameters to control the PUSCH allocation.
%
% * PUSCH mapping type. It can be either 'A' or 'B'.
% * Symbols in a slot where the PUSCH is mapped to. It needs to be a
% contiguous allocation. For PUSCH mapping type 'A', the start symbol
% within a slot must be zero and the length can be from 4 to 14 (for normal
% CP) and up to 12 (for extended CP). For PUSCH mapping type 'B', the start
% symbol can be from any symbol in the slot
% * Slots in a frame used for the PUSCH
% * Period of the allocation in slots. If this is empty it indicates no
% repetition
% * The allocated PRBs are relative to the BWP

pusch(1).PUSCHMappingType = 'A';        % PUSCH mapping type ('A'(slot-wise),'B'(non slot-wise))
pusch(1).AllocatedSymbols = 0:13;       % Range of symbols in a slot
pusch(1).AllocatedSlots = [0 1];        % Allocated slots indices
pusch(1).AllocatedPeriod = 5;           % Allocation period in slots (empty implies no repetition)
pusch(1).AllocatedPRB = 0:10;           % PRB allocation

%%
% *DM-RS Configuration*
%
% The following DM-RS parameters can be set

% DM-RS configuration (TS 38.211 section 6.4.1.1)
pusch(1).DMRSConfigurationType = 1;    % DM-RS configuration type (1,2)
pusch(1).NumCDMGroupsWithoutData = 2;  % Number of DM-RS CDM groups without data. The value can be one of the set {1,2,3}
pusch(1).PortSet = [0];              % DM-RS ports to use for the layers. The number of ports must be same as the number of layers
pusch(1).DMRSTypeAPosition = 2;        % Mapping type A only. First DM-RS symbol position (2,3)
pusch(1).DMRSLength = 1;               % Number of front-loaded DM-RS symbols (1(single symbol),2(double symbol))
pusch(1).DMRSAdditionalPosition = 2;   % Additional DM-RS symbol positions (max range 0...3)
pusch(1).NIDNSCID = 1;                 % Scrambling identity for CP-OFDM (0...65535). Use empty ([]) to use physical layer cell identity
pusch(1).NSCID = 0;                    % Scrambling initialization for CP-OFDM (0,1)
pusch(1).NRSID = 0;                    % Scrambling identity for DFT-s-OFDM DM-RS (0...1007). Use empty ([]) to use physical layer cell identity
pusch(1).PowerDMRS = 0;                % Additional power boosting in dB
pusch(1).GroupHopping = 'enable';      % {'enable','disable','neither'}. This parameter is used only when transform precoding is enabled

%%
% The parameter |GroupHopping| is used in DM-RS sequence generation when
% transform precoding is enabled. This can be set to
%
% * 'enable' to indicate the presence of group hopping. It is configured by
% higher-layer parameter |_sequenceGroupHopping_|
% * 'disable' to indicate the presence of sequence hopping. It is
% configured by higher-layer parameter |_sequenceHopping_|
% * 'neither' to indicate both group hopping and sequence hopping are not
% present
%
% Note: The number of DM-RS CDM groups without data depends on the
% configuration type. The maximum number of DM-RS CDM groups can be 2 for
% DM-RS configuration type 1 and it can be 3 for DM-RS configuration type
% 2.
%%
% *UCI on PUSCH*
%
% The following parameters must be set to transmit UCI on PUSCH in
% overlapping slots:
%
% * Disable UL-SCH transmission on the overlapping slots of PUSCH (1/0).
% When set to 1, UL-SCH transmission is disabled on PUSCH. The example
% considers there is UL-SCH transmission all the time on PUSCH. A provision
% is provided to disable the UL-SCH transmission on the overlapping slots
% of PUSCH and PUCCH
% * |BetaOffsetACK|, |BetaOffsetCSI1| and |BetaOffsetCSI2| can be set from
% the tables 9.3-1, 9.3-2 TS 38.213 Section 9.3
% * |ScalingFactor| is provided by higher layer parameter |_scaling_|, as
% per TS 38.212, Section 6.3.2.4. The possible value is one of the set
% {0.5, 0.65, 0.8, 1}. This is used to limit the number of resource
% elements assigned to UCI on PUSCH

pusch(1).DisableULSCH = 1;             % Disable UL-SCH on overlapping slots of PUSCH and PUCCH
pusch(1).BetaOffsetACK = 1;            % Power factor of HARQ-ACK
pusch(1).BetaOffsetCSI1 = 2;           % Power factor of CSI part 1
pusch(1).BetaOffsetCSI2 = 2;           % Power factor of CSI part 2
pusch(1).ScalingFactor = 1;            % Scaling factor (0.5, 0.65, 0.8, 1)

%%
% *Specifying Multiple PUSCH Instances*
%
% A second PUSCH sequence instance is specified next using the second BWP.

pusch(2) = pusch(1);
pusch(2).Enable = 1;
pusch(2).BWP = 2;
pusch(2).AllocatedSymbols = 0:11;
pusch(2).AllocatedSlots = [5 6 7 8];
pusch(2).AllocatedPRB = 5:10;
pusch(2).AllocatedPeriod = 10;
pusch(2).TransformPrecoding = 1;
pusch(2).IntraSlotFreqHopping = 'disabled';
pusch(2).GroupHopping = 'neither';
pusch(2).NLayers = 1;
pusch(2).PortSet = 1;
pusch(2).RNTI = 0;

%% Waveform Generation
% This section collects all the parameters into the carrier configuration
% and generates the waveform.

% Collect together channel oriented parameter sets into a single
% configuration
waveconfig.Carriers = carriers;
waveconfig.BWP = bwp;
waveconfig.PUCCH = pucch;
waveconfig.PUSCH = pusch;

% Generate complex baseband waveform
[waveform,bwpset] = hNRUplinkWaveformGenerator(waveconfig);

%%
% The waveform generator also plots the SCS carrier alignment and the
% resource grids for the bandwidth parts (this is controlled by the field
% |DisplayGrids| in the carrier configuration). The following plots are
% generated:
%
% * Resource grid showing the location of the components (PUCCH and PUSCH)
% in each BWP. This does not plot the power of the signals, just their
% location in the grid
% * Schematic diagram of SCS carrier alignment with the associated
% guardbands
% * Generated waveform in the frequency domain for each BWP. This includes
% the PUCCH and PUSCH instances
%%
% The waveform generator function returns the time domain waveform and a
% struct array |bwpset|, which contains the following fields:
%
% * The resource grid corresponding to this BWP
% * The resource grid of the overall bandwidth containing the channels and
% signals in this BWP
% * An info structure with information corresponding to the BWP. The
% contents of this info structure for the first BWP are shown below:

disp('Information associated to BWP 1:')
disp(bwpset(1).Info)
%%
% Note that the generated resource grid is a 3D matrix where the different
% planes represent the antenna ports. For the different physical channels
% and signals the lowest port is mapped to the first plane of the grid.
