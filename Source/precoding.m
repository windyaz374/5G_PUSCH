function z = precoding(in,codebook,nlayer,nant,tpmi,tp)
in = in';
if codebook == 0                %codebookbased transmission
    z = in;
else                            %non-codebookbased transmission
    if nlayer == 1
        if nant == 1            %1layer-1antenna
            z = in;
        elseif nant == 2        %1layer-2antenna
            w = w12();
            w = w(tpmi*nlayer + (1:nlayer),:);
            in = in';
            z = in*w;
        elseif nant == 4        
            if tp == 1
                w = w14_tp;     %1layer-4antenna-transformprecoding
                w = w(tpmi*nlayer + (1:nlayer),:);
                in = in';
                z = in*w;
            else
                w = w14_notp;  %1layer-4antenna-notransformprecoding
                w = w(tpmi*nlayer + (1:nlayer),:);
                in = in';
                z = in*w;
            end
        end
    elseif nlayer == 2          
        if nant == 2            %2layer-2antenna
            w = w22();
            w = w(tpmi*nlayer + (1:nlayer),:);
            in_conc = [in{1};in{2}]';
            z = in_conc*w;
        elseif nant == 4        %2layer-4antenna
            w = w24();
            w = w(tpmi*nlayer + (1:nlayer),:);
            in_conc = [in{1};in{2}]';
            z = in_conc*w;
        end
    elseif nlayer == 3          %3layers-4antenna          
        w = w34();
        w = w(tpmi*nlayer + (1:nlayer),:);
        in_conc = [in{1};in{2};in{3}]';
        z = in_conc*w;
    else
        w = w44();              %4layers-4antenna 
        w = w(tpmi*nlayer + (1:nlayer),:);
        in_conc = [in{1};in{2};in{3};in{4}]';
        z = in_conc*w;
    end
end

z = z';
end
function W12 = w12()

    % Table 6.3.1.5-1
    %              TPMI
    W12 = [1   0;  %  0
           0   1;  %  1
           1   1;  %  2
           1  -1;  %  3
           1  1j;  %  4
           1 -1j]; %  5
    W12 = W12 / sqrt(2);
    
end

function W14 = w14_tp()

    % Table 6.3.1.5-2
    %                         TPMI
    W14_tp = [1   0   0   0;  %  0
              0   1   0   0;  %  1
              0   0   1   0;  %  2
              0   0   0   1;  %  3
              1   0   1   0;  %  4
              1   0  -1   0;  %  5
              1   0  1j   0;  %  6
              1   0 -1j   0;  %  7
              0   1   0   1;  %  8
              0   1   0  -1;  %  9
              0   1   0  1j;  % 10
              0   1   0 -1j;  % 11
              1   1   1  -1;  % 12
              1   1  1j  1j;  % 13
              1   1  -1   1;  % 14
              1   1 -1j -1j;  % 15
              1  1j   1  1j;  % 16
              1  1j  1j   1;  % 17
              1  1j  -1 -1j;  % 18
              1  1j -1j  -1;  % 19
              1  -1   1   1;  % 20
              1  -1  1j -1j;  % 21
              1  -1  -1  -1;  % 22
              1  -1 -1j  1j;  % 23
              1 -1j   1 -1j;  % 24
              1 -1j  1j  -1;  % 25
              1 -1j  -1  1j;  % 26
              1 -1j -1j   1]; % 27
    W14 = W14_tp / 2;
    
end

function W14 = w14_notp()
    
    % Table 6.3.1.5-3
    %                           TPMI
    W14_notp = [1   0   0   0;  %  0
                0   1   0   0;  %  1
                0   0   1   0;  %  2
                0   0   0   1;  %  3
                1   0   1   0;  %  4
                1   0  -1   0;  %  5
                1   0  1j   0;  %  6
                1   0 -1j   0;  %  7
                0   1   0   1;  %  8
                0   1   0  -1;  %  9
                0   1   0  1j;  % 10
                0   1   0 -1j;  % 11
                1   1   1   1;  % 12
                1   1  1j  1j;  % 13
                1   1  -1  -1;  % 14
                1   1 -1j -1j;  % 15
                1  1j   1  1j;  % 16
                1  1j  1j  -1;  % 17
                1  1j  -1 -1j;  % 18
                1  1j -1j   1;  % 19
                1  -1   1  -1;  % 20
                1  -1  1j -1j;  % 21
                1  -1  -1   1;  % 22
                1  -1 -1j  1j;  % 23
                1 -1j   1 -1j;  % 24
                1 -1j  1j   1;  % 25
                1 -1j  -1  1j;  % 26
                1 -1j -1j  -1]; % 27
    W14 = W14_notp / 2;
    
end

function W22 = w22()

    % Table 6.3.1.5-4
    %              TPMI
    W22 = [1   0;  %  0
           0   1;
           1   1;  %  1
           1  -1;
           1  1j;  %  2
           1 -1j];
    W22(1:2,:) = W22(1:2,:) / sqrt(2);
    W22(3:end,:) = W22(3:end,:) / 2;

end

function W24 = w24()

    % Table 6.3.1.5-5
    %                      TPMI
    W24 = [1   0   0   0;  %  0
           0   1   0   0;
           1   0   0   0;  %  1
           0   0   1   0;
           1   0   0   0;  %  2
           0   0   0   1;
           0   1   0   0;  %  3
           0   0   1   0;
           0   1   0   0;  %  4
           0   0   0   1;
           0   0   1   0;  %  5
           0   0   0   1;
           1   0   1   0;  %  6
           0   1   0 -1j;
           1   0   1   0;  %  7
           0   1   0  1j;
           1   0 -1j   0;  %  8
           0   1   0   1;
           1   0 -1j   0;  %  9
           0   1   0  -1;
           1   0  -1   0;  % 10
           0   1   0 -1j;
           1   0  -1   0;  % 11
           0   1   0  1j;
           1   0  1j   0;  % 12
           0   1   0   1;
           1   0  1j   0;  % 13
           0   1   0  -1;
           1   1   1   1;  % 14
           1   1  -1  -1;
           1   1  1j  1j;  % 15
           1   1 -1j -1j;
           1  1j   1  1j;  % 16
           1  1j  -1 -1j;
           1  1j  1j  -1;  % 17
           1  1j -1j   1;
           1  -1   1  -1;  % 18
           1  -1  -1   1;
           1  -1  1j -1j;  % 19
           1  -1 -1j  1j;
           1 -1j   1 -1j;  % 20
           1 -1j  -1  1j;
           1 -1j  1j   1;  % 21
           1 -1j -1j  -1];
    W24(1:28,:) = W24(1:28,:) / 2;
    W24(29:end,:) = W24(29:end,:) / (2*sqrt(2));
    
end

function W34 = w34()

    % Table 6.3.1.5-6
    %                     TPMI
    W34 = [1   0   0   0; %  0
           0   1   0   0;
           0   0   1   0;
           1   0   1   0; %  1
           0   1   0   0;
           0   0   0   1;
           1   0  -1   0; %  2
           0   1   0   0;
           0   0   0   1;
           1   1   1   1; %  3
           1  -1   1  -1;
           1   1  -1  -1;
           1   1  1j  1j; %  4
           1  -1  1j -1j;
           1   1 -1j -1j;
           1  -1   1  -1; %  5
           1   1   1   1;
           1  -1  -1   1;
           1  -1  1j -1j; %  6
           1   1  1j  1j;
           1  -1 -1j  1j];
    W34(1:9,:) = W34(1:9,:) / 2;
    W34(10:end,:) = W34(10:end,:) / (2*sqrt(3));
    
end

function W44 = w44()

    % Table 6.3.1.5-7
    %                     TPMI
    W44 = [1   0   0   0; %  0
           0   1   0   0;
           0   0   1   0;
           0   0   0   1;
           1   0   1   0; %  1
           1   0  -1   0;
           0   1   0   1;
           0   1   0  -1;
           1   0  1j   0; %  2
           1   0 -1j   0;
           0   1   0  1j;
           0   1   0 -1j;
           1   1   1   1; %  3
           1  -1   1  -1;
           1   1  -1  -1;
           1  -1  -1   1;
           1   1  1j  1j; %  4
           1  -1  1j -1j;
           1   1 -1j -1j;
           1  -1 -1j  1j];
    W44(1:4,:) = W44(1:4,:) / 2;
    W44(5:12,:) = W44(5:12,:) / (2*sqrt(2));
    W44(13:end,:) = W44(13:end,:) / 4;
        
end
