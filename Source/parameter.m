%parameter

%% System config
sys.NCellId                     = 500;          %Cell ID (0...1007)
sys.FrequencyRange              = 1;
sys.BandWidth                   = 100;
sys.Numerology                  = 1;
sys.CpType                      = 0;            %normal CP
sys.NTxAnt                      = 1;
sys.NRxAnt                      = 2;
sys.BwpNRb                      = 273;
sys.BwpRbOffset                 = 0;

%% ----------------------------------------------------------%%
%HARQ Process Info
sys.harqProcFlag        = 1;    
sys.nHarqProc           = 4;
sys.rvSeq               = [0 0 0 0];

%% -----------------------------------------------------------%%
%Uplink config
%General setting
ue.UlschEnable                  = 1;
ue.TransformPrecoding           = 0;
ue.Rnti                         = 2001;         %UE ID (0...65535)
ue.nId                          = 20;           %Scrambling Identity (0...1023)
ue.CodeBookBased                = 0;            %non-CodeBookBased
ue.DmrsPortSetIdx            	= 1;            %DM-RS port to use for layer
ue.Nlayers                      = 1;
ue.NumDmnrCdmGroupWithoutdata   = 2;            %determine REs
ue.Tpmi                         = 0;            %transmitted precoding matrix indicator
ue.FirstSymb                    = 0;            %fist symbol PUSCH
ue.NPuschSymbAll                = 14;
ue.RaType                       = 1;
ue.FirstPrb                     = 0;
ue.NPrb                         = 1;
ue.FrequencyHoppingMode         = 0;            %Disable Frequency Hopping
ue.McsTable                     = 0;            %Table 5.1.3.1-1 ts38.214 (64QAM)
ue.Mcs                          = 17;
ue.ILbrm                        = 0;            %Limited Buffer Rate Matching
ue.nScId                        = 0;            %DMRS scarmbling initialization (0;1)
ue.NnScIdId                     = 0;            %Scrambling identity (0...65535)
ue.DmrsConfigurationType        = 0;            %Type 1
ue.DmrsDuration                 = 1;            %single symbol
ue.DmrsAdditionalPosition       = 1;            
ue.PuschMappingType             = 0;            %TypeA
ue.DmrsTypeAPosition            = 2;            %DMRS symbol position in TypeA
ue.HoppingMode                  = 0;            %Disable
ue.NRsId                        = 0;            %DMRS Scrambling Identity for DFTs-OFDM
ue.NPrbOh                       = 0;            
ue.nCw                          = 1;
ue.TpPiBpsk                     = 0;            %Disable

%% -----------------------------------------------------------%%
%Channel config
chcfg.infFlag                   = 0;            %Interference Flag Disable
chcfg.ChannelFlag               = 1;            %Enable
chcfg.ChannelProfile            = 'TDLB100-400';%Propagation Condition
chcfg.gNoiseFlag                = 1;            %Add Gauss Noise 
chcfg.SNRdB                     = 0;    
chcfg.To                        = 0;            %Time offset
chcfg.Fo                        = 0;            %Frenquency offset




