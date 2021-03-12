function BM=base_matrix(LDPCgraph,setIdx)
bgs=load('baseGraph.mat');
switch LDPCgraph
        case 'type1'
            switch setIdx
                case 0
                    BM = bgs.BG1S1;
                case 1
                    BM = bgs.BG1S2;
                case 2
                    BM = bgs.BG1S3;
                case 3
                    BM = bgs.BG1S4;
                case 4
                    BM = bgs.BG1S5;
                case 5
                    BM = bgs.BG1S6;
                case 6
                    BM = bgs.BG1S7;
                otherwise % 7
                    BM = bgs.BG1S8;
            end
        otherwise % LDPCgraph = 'type2'
            switch setIdx
                case 0
                    BM = bgs.BG2S1;
                case 1
                    BM = bgs.BG2S2;
                case 2
                    BM = bgs.BG2S3;
                case 3
                    BM = bgs.BG2S4;
                case 4
                    BM = bgs.BG2S5;
                case 5
                    BM = bgs.BG2S6;
                case 6
                    BM = bgs.BG2S7;
                otherwise % 7
                    BM = bgs.BG2S8;
            end
end
end
   