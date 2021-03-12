%------------------------DetermineTBS------------------------------
function [TBS,Nre_prime,NPrb_Dmrs]=tbs(NPrb,NPuschSymbAll,Nlayers,NPrbOh,Qm,R,type,mapping,len,addpos,cdmgroup)
%Determine number of REs for DMRS symbols in 1 PRB
NPrb_Dmrs = dmrs_re(type,mapping,len,addpos,cdmgroup);
%REs for PUSCH in 1 PRB
Nre_prime = 12*NPuschSymbAll - NPrb_Dmrs - NPrbOh;
%The total REs allocated for PUSCH 
Nre = min(156,Nre_prime)*NPrb;
%Number of information bits (Ninfo)
Ninfo = Nre*R*Qm*Nlayers;
if Ninfo > 3824
    n = floor(log2(Ninfo-24))-5;
    Ninfo_prime=2^n*round((Ninfo-24)/2^n);
    if R <= 1/4
        C = ceil((Ninfo_prime+24)/3816);
        TBS = 8*C*ceil((Ninfo_prime+24)/(8*C))-24;
    else
        if Ninfo_prime > 8424
            C = ceil((Ninfo_prime+24)/8424);
            TBS = 8*C*ceil((Ninfo_prime+24)/(8*C))-24;
        else
            TBS = 8*ceil((Ninfo_prime+24)/8);
        end
    end
else 
    n = max(3,floor(log2(Ninfo))-6);
    Ninfo_prime = max(24,2^n*floor(Ninfo/2^n));
    %fprintf('%d\n', Ninfo_prime);
    %disp('Use Table 5.1.3.2-1 Ts38.214 find closet TBS that os not less than Ninfo_prime');
    %TBS = input('TBS read from 5.1.3.2-1 Ts38.214');
    TBSvalue = [24 32 40 48 56 64 72 80 88 96 104 112 120 128 136 144 152 160 168 176 184 192 208 224 240 256 272 288 304 320 336 352 ...
                368 384 408 432 456 480 504 528 552 576 608 640 672 704 736 768 808 848 888 928 984 1032 1064 1128 1160 1192 1224 1256 ...
                1320 1352 1416 1480 1544 1608 1672 1736 1800 1864 1928 2024 2088 2152 2216 2280 2408 2472 2536 2600 2664 2728 2792 2856 2976 3104 3240 3368 3496 3624 3752 3824];
    value =  TBSvalue(TBSvalue >= Ninfo_prime);
    TBS = value(1);
end
end

function NPrb_Dmrs=dmrs_re(type,mapping,len,addpos,cdmgroup)
if type == 0                 %Dmrsconfig Type 1
    if mapping == 0          %Pusch mapping Type A
        NPrb_Dmrs = 6*len*(addpos+1)*cdmgroup;
    else                    %Pusch mapping Type B
        NPrb_Dmrs = 6*len*cdmgroup;
    end 
else                        %Dmrsconfig Type 2
    if mapping == 0          %Pusch mapping Type A
        NPrb_Dmrs = 4*len*(addpos+1)*cdmgroup;
    else                    %Pusch mapping Type B
        NPrb_Dmrs = 4*len*cdmgroup;
    end
end
end
    

    
    

